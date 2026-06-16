<%@ page import="java.util.*, model.user, model.Expense, dao.ExpenseDAO" %>
<%@ page import="java.text.SimpleDateFormat, java.text.NumberFormat, java.util.Locale" %>
<%@ page session="true" %>
<%
    NumberFormat currencyFormat = NumberFormat.getNumberInstance(Locale.US);

    user user = (user) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    ExpenseDAO dao = new ExpenseDAO();
    List<Expense> list = dao.getExpensesByUser(user.getId());

    Map<String, Double> monthlyTotals = new TreeMap<>();
    Map<String, Double> yearlyTotals = new TreeMap<>();
    Map<String, Double> titleTotals = new HashMap<>();

    SimpleDateFormat monthFormat = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");

    for (Expense e : list) {
        String monthKey = monthFormat.format(e.getDate());
        String yearKey = yearFormat.format(e.getDate());

        monthlyTotals.put(monthKey, monthlyTotals.getOrDefault(monthKey, 0.0) + e.getAmount());
        yearlyTotals.put(yearKey, yearlyTotals.getOrDefault(yearKey, 0.0) + e.getAmount());
        titleTotals.put(e.getTitle(), titleTotals.getOrDefault(e.getTitle(), 0.0) + e.getAmount());
    }

    // --- SALARY AND ALERT LOGIC ---
    Double monthlySalary = (Double) session.getAttribute("monthlySalary");
    if (monthlySalary == null || monthlySalary == 0.0) {
        // If salary is not set, set a temporary high value or skip alert generation
        monthlySalary = 10000000.0; // Use a high default to prevent false alerts if not set
    }
    double yearlySalary = monthlySalary * 12.0;

    StringBuilder alertMessage = new StringBuilder();
    int limitPercentage = 60;
    boolean triggerAlert = false;

    // Check Monthly Limit
    for (Map.Entry<String, Double> entry : monthlyTotals.entrySet()) {
        double percentage = (entry.getValue() / monthlySalary) * 100;
        if (percentage > limitPercentage) {
            triggerAlert = true;
            String monthName = new SimpleDateFormat("MMM yyyy").format(monthFormat.parse(entry.getKey()));
            alertMessage.append("WARNING: ").append(monthName).append(" expenses exceeded ").append(limitPercentage).append("% of your monthly salary! Total: Rs ").append(currencyFormat.format(entry.getValue())).append(".\\n");
        }
    }
    
    // Check Yearly Limit (using the yearly total from the map if it exists)
    for (Map.Entry<String, Double> entry : yearlyTotals.entrySet()) {
        double percentage = (entry.getValue() / yearlySalary) * 100;
        if (percentage > limitPercentage) {
            triggerAlert = true;
            alertMessage.append("CRITICAL: ").append(entry.getKey()).append(" expenses exceeded ").append(limitPercentage).append("% of your yearly salary! Total: Rs ").append(currencyFormat.format(entry.getValue())).append(".\\n");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expense Analysis</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --bg-color: #0d1117;
            --card-bg: #161b22;
            --text-color: #e6edf3;
            --accent-blue: #00c2ff;
            --accent-green: #00ff88;
            --accent-pink: #ff007f;
            --accent-yellow: #ffd500;
            --alert-red: #ff4d4f; /* A standard alert red */
        }

        body {
            font-family: "Poppins", sans-serif;
            background: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 0;
        }
        
        /* --- ALERT STYLES --- */
        .alert-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.5s ease;
        }

        .alert-modal.show {
            opacity: 1;
            pointer-events: auto;
        }

        .alert-content {
            background: var(--card-bg);
            border: 3px solid var(--alert-red); /* Use alert red border */
            border-radius: 12px;
            padding: 30px;
            max-width: 450px;
            width: 90%;
            box-shadow: 0 0 30px rgba(255, 77, 79, 0.5); /* Use alert red shadow */
            position: relative;
            animation: bounceIn 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        @keyframes bounceIn {
            0% { transform: scale(0.7); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        .alert-content h4 {
            /* Updated: Use bold red text */
            color: var(--alert-red); 
            font-size: 1.8rem;
            margin-top: 0;
            border-bottom: 2px solid var(--alert-red);
            padding-bottom: 10px;
            font-weight: 700;
        }

        .alert-message {
            white-space: pre-line;
            font-size: 1rem;
            line-height: 1.6;
            color: var(--text-color);
            margin-bottom: 20px;
            font-weight: 600;
        }

        .alert-close {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 2rem;
            color: var(--alert-red);
            cursor: pointer;
            line-height: 1;
            transition: color 0.3s;
        }

        .alert-close:hover {
            color: #fff;
        }
        /* --------------------------- */

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--card-bg);
            padding: 15px 25px;
            border-bottom: 2px solid var(--accent-blue);
            flex-wrap: wrap;
        }

        .navbar h2 {
            color: var(--accent-blue);
            font-weight: 700;
            font-size: 1.6rem;
            margin: 0;
        }

        .nav-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .nav-btn {
            background: none;
            border: 2px solid var(--accent-green);
            color: var(--accent-green);
            border-radius: 10px;
            padding: 12px 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1rem;
        }

        .nav-btn:hover {
            background: var(--accent-green);
            color: #0d1117;
            transform: scale(1.05);
        }

        .logout-btn {
            border-color: var(--accent-pink);
            color: var(--accent-pink);
        }

        .logout-btn:hover {
            background: var(--accent-pink);
            color: #0d1117;
        }

        .container {
            padding: 40px 20px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 30px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 14px;
            padding: 30px;
            width: 100%;
            max-width: 1200px;
            box-shadow: 0 0 15px rgba(0, 194, 255, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h3 {
            text-align: center;
            color: var(--accent-blue);
            font-weight: 600;
            margin-bottom: 20px;
        }

        .analysis-select {
            margin-bottom: 25px;
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .select-btn {
            background: linear-gradient(90deg, var(--accent-blue), var(--accent-green));
            border: none;
            color: #0d1117;
            border-radius: 12px;
            padding: 16px 35px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }

        .select-btn:hover {
            transform: scale(1.08);
            background: linear-gradient(90deg, var(--accent-green), var(--accent-blue));
        }

        .chart-section {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            gap: 40px;
            width: 100%;
        }

        canvas {
            width: 380px !important;
            height: 380px !important;
        }

        .details-box {
            margin-top: 30px;
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid var(--accent-blue);
            border-radius: 12px;
            padding: 20px;
            width: 80%;
            max-width: 400px;
            text-align: center;
        }

        .details-box h4 {
            color: var(--accent-green);
            margin-bottom: 10px;
            font-size: 1.2rem;
        }

        .details-box p {
            font-size: 1rem;
            color: var(--text-color);
            line-height: 1.6;
        }

        @media (max-width: 900px) {
            .chart-section {
                flex-direction: column;
            }
            canvas {
                width: 100% !important;
                height: 300px !important;
            }
        }
    </style>
</head>
<body>

    <div id="expenseAlertModal" class="alert-modal">
        <div class="alert-content">
            <span class="alert-close" onclick="closeAlert()">&times;</span>
            <h4>EXPENSE LIMIT REACHED!</h4> <p id="alertMessageContent" class="alert-message"></p>
        </div>
    </div>
    <div class="navbar">
        <h2>Expense Analysis</h2>
        <div class="nav-buttons">
            <form action="dashboard.jsp" method="get">
                <button type="submit" class="nav-btn">Dashboard</button>
            </form>
            <form action="logout.jsp" method="get">
                <button type="submit" class="nav-btn logout-btn">Logout</button>
            </form>
        </div>
    </div>

    <div class="container">
        <div class="card">
            <h3>View Your Spending Insights</h3>

            <div class="analysis-select">
                <button class="select-btn" onclick="showCharts('monthly')">Monthly Analysis</button>
                <button class="select-btn" onclick="showCharts('yearly')">Yearly Analysis</button>
            </div>

            <div class="chart-section">
                <canvas id="donutChart"></canvas>
                <canvas id="barChart"></canvas>
            </div>

            <div id="details" class="details-box" style="display: none;">
                <h4>Most Spent Category</h4>
                <p id="topTitle"></p>
                <p id="topAmount"></p>
            </div>
        </div>
    </div>

    <script>
        const monthlyLabels = [<% for (String k : monthlyTotals.keySet()) { %>"<%= k %>",<% } %>];
        const monthlyValues = [<% for (double v : monthlyTotals.values()) { %><%= v %>,<% } %>];
        const yearlyLabels = [<% for (String k : yearlyTotals.keySet()) { %>"<%= k %>",<% } %>];
        const yearlyValues = [<% for (double v : yearlyTotals.values()) { %><%= v %>,<% } %>];

        // Data for analyzing the single most expensive title (category) overall
        const titleLabels = [<% for (String k : titleTotals.keySet()) { %>"<%= k %>",<% } %>];
        const titleValues = [<% for (double v : titleTotals.values()) { %><%= v %>,<% } %>];


        const colors = ['#00c2ff','#00ff88','#ff007f','#ffd500','#8b5cf6','#22d3ee','#f43f5e','#10b981','#f59e0b'];

        let donutChart, barChart;

        function destroyCharts() {
            if (donutChart) donutChart.destroy();
            if (barChart) barChart.destroy();
        }

        function showCharts(type) {
            destroyCharts();

            const ctx1 = document.getElementById('donutChart').getContext('2d');
            const ctx2 = document.getElementById('barChart').getContext('2d');

            const labels = type === 'monthly' ? monthlyLabels : yearlyLabels;
            const dataValues = type === 'monthly' ? monthlyValues : yearlyValues;
            
            // Logic to find the overall most spent expense title (category)
            let maxTitleIndex = titleValues.indexOf(Math.max(...titleValues));
            let topTitleCategory = titleLabels[maxTitleIndex];
            let topTitleAmount = titleValues[maxTitleIndex];

            // Show details dynamically using the overall top Title/Category
            document.getElementById('details').style.display = 'block';
            document.getElementById('topTitle').innerText = topTitleCategory;
            document.getElementById('topAmount').innerText = 'Rs ' + topTitleAmount.toLocaleString();

            // 3D Animated Doughnut Chart (Monthly or Yearly Breakdown)
            donutChart = new Chart(ctx1, {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: dataValues,
                        backgroundColor: colors,
                        borderColor: '#0d1117',
                        borderWidth: 2,
                    }]
                },
                options: {
                    cutout: '55%',
                    rotation: 0,
                    plugins: {
                        title: {
                            display: true,
                            text: type === 'monthly' ? 'Monthly Expense Distribution' : 'Yearly Expense Distribution',
                            color: '#00c2ff',
                            font: { size: 18, weight: 'bold' }
                        },
                        legend: {
                            labels: { color: '#e6edf3', font: { size: 13 } }
                        }
                    },
                    animation: {
                        animateScale: true,
                        animateRotate: true,
                        duration: 1600
                    }
                }
            });

            // Bar Chart for clarity (Monthly or Yearly Overview)
            barChart = new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: type === 'monthly' ? 'Monthly Spending' : 'Yearly Spending',
                        data: dataValues,
                        backgroundColor: colors,
                        borderColor: '#0d1117',
                        borderWidth: 1
                    }]
                },
                options: {
                    plugins: {
                        legend: { labels: { color: '#e6edf3' } },
                        title: {
                            display: true,
                            text: type === 'monthly' ? 'Monthly Spending Overview' : 'Yearly Spending Overview',
                            color: '#00ff88',
                            font: { size: 16, weight: 'bold' }
                        }
                    },
                    scales: {
                        x: { ticks: { color: '#e6edf3' } },
                        y: { ticks: { color: '#e6edf3' } }
                    },
                    animation: { duration: 1500, easing: 'easeOutBounce' }
                }
            });
        }
        
        // --- ALERT FUNCTIONS ---
        const alertModal = document.getElementById('expenseAlertModal');
        const alertMsg = document.getElementById('alertMessageContent');
        const jsAlertMessage = '<%= alertMessage.toString() %>';
        const triggerAlert = <%= triggerAlert %>;
        
        function showAlert() {
            if (triggerAlert) {
                alertMsg.innerText = jsAlertMessage;
                alertModal.classList.add('show');
                
                // Auto-close after 10 seconds
                setTimeout(closeAlert, 10000);
            }
        }
        
        function closeAlert() {
            alertModal.classList.remove('show');
        }

        // Run alert check and show default chart when page loads
        window.onload = function() {
            showAlert();
            // Show Monthly Analysis by default
            if (monthlyLabels.length > 0) {
                 showCharts('monthly');
            } else if (yearlyLabels.length > 0) {
                 showCharts('yearly');
            }
        };
        // -----------------------
    </script>
</body>
</html>
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
    String action = request.getParameter("action");

    if ("add".equals(action)) {
        String title = request.getParameter("title");
        String amount = request.getParameter("amount");
        String date = request.getParameter("date");

        if (title != null && amount != null && date != null && !title.isEmpty()) {
            Expense exp = new Expense();
            exp.setUserId(user.getId());
            exp.setTitle(title);
            exp.setAmount(Double.parseDouble(amount));
            exp.setDate(java.sql.Date.valueOf(date));
            dao.addExpense(exp);
        }
    }

    if ("delete".equals(action)) {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            dao.deleteExpense(Integer.parseInt(idStr), user.getId());
        }
    }

    List<Expense> list = dao.getExpensesByUser(user.getId());
    Collections.sort(list, (e1, e2) -> e2.getDate().compareTo(e1.getDate()));

    double allTimeTotal = 0.0;
    Map<String, Double> monthlyTotals = new TreeMap<>(Collections.reverseOrder());
    Map<String, Double> yearlyTotals = new TreeMap<>(Collections.reverseOrder());

    SimpleDateFormat monthFormat = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");

    for (Expense e : list) {
        allTimeTotal += e.getAmount();
        String monthKey = monthFormat.format(e.getDate());
        String yearKey = yearFormat.format(e.getDate());
        monthlyTotals.put(monthKey, monthlyTotals.getOrDefault(monthKey, 0.0) + e.getAmount());
        yearlyTotals.put(yearKey, yearlyTotals.getOrDefault(yearKey, 0.0) + e.getAmount());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expense Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-color: #0d1117;
            --card-bg: #161b22;
            --text-color: #e6edf3;
            --accent-blue: #00c2ff;
            --accent-green: #00ff88;
            --accent-pink: #ff007f;
            --accent-yellow: #ffd500;
        }

        body {
            font-family: "Poppins", sans-serif;
            background: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* NAVBAR */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--card-bg);
            padding: 15px 25px;
            flex-wrap: wrap;
            border-bottom: 2px solid var(--accent-blue);
        }

        .navbar h2 {
            color: var(--accent-blue);
            margin: 0;
            font-weight: 700;
            font-size: 1.5rem;
        }

        .nav-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .nav-btn {
            background: none;
            border: 2px solid var(--accent-green);
            color: var(--accent-green);
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
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

        /* MAIN CONTAINER */
        .container {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 30px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 25px;
            width: 100%;
            max-width: 950px;
            box-shadow: 0 0 20px rgba(0, 194, 255, 0.15);
        }

        h3 {
            text-align: center;
            color: var(--accent-blue);
            font-weight: 600;
            margin-bottom: 10px;
        }

        /* TABLES */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            color: var(--text-color);
            font-size: 0.95rem;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        th {
            border-bottom: 2px solid var(--accent-blue);
            color: var(--accent-yellow);
        }

        tr:nth-child(even) {
            background: rgba(255,255,255,0.03);
        }

        tr:hover {
            background: rgba(0, 194, 255, 0.1);
            transition: 0.3s;
        }

        .delete-btn {
            background: none;
            border: 2px solid var(--accent-pink);
            color: var(--accent-pink);
            border-radius: 8px;
            padding: 6px 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .delete-btn:hover {
            background: var(--accent-pink);
            color: #0d1117;
            transform: scale(1.05);
        }

        .total-spent {
            text-align: right;
            padding-top: 15px;
            font-size: 1.2em;
            color: var(--accent-green);
            border-top: 1px solid rgba(255, 255, 255, 0.2);
            margin-top: 10px;
            font-weight: bold;
        }

        .aggregated-table {
            margin-top: 30px;
        }

        .table-data-bold {
            font-weight: 600;
            color: var(--accent-blue);
        }

        /* CODE/GRAPH ANALYSIS BUTTON */
        .code-analysis-btn {
            display: inline-block;
            margin-top: 25px;
            padding: 14px 28px;
            font-size: 1rem;
            font-weight: 700;
            color: #0d1117;
            background: linear-gradient(90deg, var(--accent-blue), var(--accent-green));
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: transform 0.3s ease, background 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .code-analysis-btn:hover {
            transform: scale(1.06);
            background: linear-gradient(90deg, var(--accent-green), var(--accent-blue));
        }

        /* RESPONSIVE DESIGN */
        @media (max-width: 900px) {
            .card {
                padding: 20px;
            }

            table {
                font-size: 0.9rem;
            }

            th, td {
                padding: 8px;
            }
        }

        @media (max-width: 600px) {
            .navbar {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }

            .nav-buttons {
                justify-content: center;
            }

            .card {
                padding: 15px;
            }

            .code-analysis-btn {
                width: 100%;
                padding: 12px 0;
            }
        }
    </style>
</head>

<body>
    <div class="navbar">
        <h2>Expense Dashboard</h2>
        <div class="nav-buttons">
            <form action="dashboard.jsp" method="get" style="display:inline;">
                <button type="submit" class="nav-btn">Home</button>
            </form>
            <form action="logout.jsp" method="get" style="display:inline;">
                <button type="submit" class="nav-btn logout-btn">Logout</button>
            </form>
        </div>
    </div>

    <div class="container">
        <div class="card">
            <h3>Detailed Transactions (Newest First)</h3>
            <table>
                <tr>
                    <th>Title</th>
                    <th>Amount</th>
                    <th>Date</th>
                    <th>Action</th>
                </tr>
                <% for (Expense e : list) { %>
                    <tr>
                        <td><%= e.getTitle() %></td>
                        <td>Rs <%= currencyFormat.format(e.getAmount()) %></td>
                        <td><%= e.getDate() %></td>
                        <td>
                            <form method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= e.getId() %>">
                                <button class="delete-btn">Delete</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
            </table>

            <div class="total-spent">
                All-Time Total Spent: Rs <%= currencyFormat.format(allTimeTotal) %>
            </div>

            <h3 class="aggregated-table">Monthly Totals</h3>
            <table>
                <tr>
                    <th>Month & Year</th>
                    <th>Total Spent (Rs)</th>
                </tr>
                <% for (Map.Entry<String, Double> entry : monthlyTotals.entrySet()) { %>
                    <tr>
                        <td><%= new SimpleDateFormat("MMM yyyy").format(monthFormat.parse(entry.getKey())) %></td>
                        <td class="table-data-bold">Rs <%= currencyFormat.format(entry.getValue()) %></td>
                    </tr>
                <% } %>
            </table>

            <h3 class="aggregated-table">Yearly Totals</h3>
            <table>
                <tr>
                    <th>Year</th>
                    <th>Total Spent (Rs)</th>
                </tr>
                <% for (Map.Entry<String, Double> entry : yearlyTotals.entrySet()) { %>
                    <tr>
                        <td><%= entry.getKey() %></td>
                        <td class="table-data-bold">Rs <%= currencyFormat.format(entry.getValue()) %></td>
                    </tr>
                <% } %>
            </table>

            <div style="text-align:center;">
                <form action="codeanalysis.jsp" method="get">
                    <button type="submit" class="code-analysis-btn">GRAPH ANALYSIS</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
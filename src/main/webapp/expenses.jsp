<%@ page import="dao.ExpenseDAO,model.Expense,model.user,java.util.*" %>
<%@ page session="true" %>
<%
    // ✅ Session check
    user user = (user) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // --- SALARY MANAGEMENT LOGIC ---
    // Use session to store salary for demonstration, as DB logic isn't provided.
    Double monthlySalary = (Double) session.getAttribute("monthlySalary");
    if (monthlySalary == null) {
        monthlySalary = 0.0;
    }

    String salaryAction = request.getParameter("salaryAction");
    String monthlySalaryStr = request.getParameter("monthlySalary");
    
    if ("saveSalary".equals(salaryAction) && monthlySalaryStr != null) {
        try {
            double newMonthlySalary = Double.parseDouble(monthlySalaryStr);
            if (newMonthlySalary >= 0) {
                // Save the new monthly salary to the session
                session.setAttribute("monthlySalary", newMonthlySalary);
                monthlySalary = newMonthlySalary;
            }
        } catch (NumberFormatException e) {
            // Handle invalid input
        }
    }
    
    double yearlySalary = monthlySalary * 12.0;
    // ---------------------------------
    
    // --- EXPENSE MANAGEMENT LOGIC ---
    String action = request.getParameter("action");
    String title = request.getParameter("title");
    String amount = request.getParameter("amount");
    String date = request.getParameter("date");
    
    ExpenseDAO dao = new ExpenseDAO();

    // ✅ Add expense logic
    if ("add".equals(action) && title != null && amount != null && date != null) {
        try {
             if (!title.trim().isEmpty() && Double.parseDouble(amount) >= 0) {
                Expense exp = new Expense();
                exp.setUserId(user.getId());
                exp.setTitle(title.trim());
                exp.setAmount(Double.parseDouble(amount));
                exp.setDate(java.sql.Date.valueOf(date));
        
                dao.addExpense(exp);
             }
        } catch (NumberFormatException e) {
            System.out.println("Invalid amount entered: " + amount);
        }
    }

    // ✅ Delete expense logic
    if ("delete".equals(action)) {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                dao.deleteExpense(id, user.getId());
            } catch (NumberFormatException e) {
                System.out.println("Invalid expense ID for deletion: " + idStr);
            }
        }
    }

    // ✅ Get all expenses of logged-in user
    List<Expense> list = dao.getExpensesByUser(user.getId());
%>
<html>
<head>
  <title>Expenses</title>
  <style>
    :root {
        --bg-color-2: #264653; /* Dark Blue/Green */
        --card-bg-color-dark: #264653dd; /* Semi-transparent dark card background */
        --text-color-light: #ffffff; /* White text for contrast */
        --link-color: #48cae4; /* Light Blue */
        --link-hover-color: #0077b6; /* Darker Blue */
        --table-bg: #f1faee15; /* Very light transparent table row */
        --table-header-bg: #0077b6; /* Header blue */
        --table-row-hover: #ffffff10; /* Lighter transparent hover */
        --delete-btn-bg: #ff4c4c;
        --delete-btn-hover: #d43232;
        --input-border: #48cae4;
        --input-focus: #00b4d8;
        --income-highlight: #ffc300; /* Yellow for income calculation */
    }
    
    body {
        font-family: 'Montserrat', sans-serif;
        /* ALL TEXT IN CAPS */
        text-transform: uppercase; 
        
        /* UPDATED BACKGROUND IMAGE */
        background: url('https://i.pinimg.com/736x/d0/00/76/d00076e5ca48c27caff497c29dba1272.jpg') no-repeat center center fixed;
        background-size: cover;
        
        display: flex;
        justify-content: center;
        align-items: flex-start; 
        min-height: 100vh;
        margin: 0;
        color: var(--text-color-light); /* Default body text is light */
        padding: 2rem;
        position: relative;
    }
    
    /* Dark overlay for readability over the background image */
    body::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.55); /* Moderate darkness */
        z-index: -1;
    }

    .container {
        max-width: 1000px;
        width: 100%;
        background: rgba(255, 255, 255, 0.1); 
        backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 20px;
        padding: 2.5rem;
        box-shadow: 0 10px 40px 0 rgba(0, 0, 0, 0.4);
        color: var(--text-color-light);
        position: relative;
        margin-top: 20px; 
        margin-bottom: 20px; /* Ensure space at the bottom */
    }

    /* UPDATED CARD BACKGROUND COLOR */
    .card {
        background: var(--card-bg-color-dark); 
        padding: 30px;
        border-radius: 16px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
        color: var(--text-color-light); /* Card text is light */
        margin: 25px auto;
        transition: transform 0.3s ease;
    }
    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 25px rgba(0, 0, 0, 0.4);
    }

    h2, h3 {
        font-weight: 700;
        letter-spacing: 0.1em;
        margin-bottom: 1.5rem;
    }

    h2 {
        color: #fff;
        border-bottom: 2px solid rgba(255, 255, 255, 0.5);
    }
    
    h3 {
        color: var(--text-color-light);
        font-size: 1.5rem;
    }

    /* Navbar links */
    .nav-links {
        position: absolute;
        top: 30px;
        right: 30px;
        display: flex;
        gap: 15px;
    }

    .nav-links a {
        text-decoration: none;
        color: #fff;
        background: linear-gradient(135deg, var(--link-color), var(--link-hover-color));
        padding: 10px 20px;
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.3s ease;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        cursor: pointer;
    }

    .nav-links a:hover {
        background: linear-gradient(135deg, var(--link-hover-color), var(--link-color));
        transform: translateY(-3px) scale(1.05);
    }

    /* Inputs */
    .card input[type="text"],
    .card input[type="number"],
    .card input[type="date"] {
        width: calc(90% - 28px);
        padding: 12px 14px;
        margin: 10px 0;
        border: 2px solid var(--input-border);
        border-radius: 10px;
        font-size: 15px;
        outline: none;
        transition: border-color 0.3s, box-shadow 0.3s;
        /* Input text must be dark so it's readable on white input field */
        color: var(--bg-color-2); 
    }
    
    /* --- SALARY ALIGNMENT FIX --- */
    .salary-row {
        display: flex;
        gap: 10px;
        margin-bottom: 15px;
    }
    
    .salary-input, .salary-display {
        flex: 1; /* Distribute space evenly */
        padding: 12px 14px;
        margin: 0; /* Remove vertical margin */
        box-sizing: border-box;
        text-align: center;
        color: var(--bg-color-2); 
    }
    /* ----------------------------- */

    
    .salary-display {
        background-color: #f0f0f0; /* Light background */
        font-weight: 700;
        border: 2px solid var(--income-highlight);
        cursor: default; /* Indicate it's read-only */
        color: var(--bg-color-2) !important;
    }

    .card input:focus {
        border-color: var(--input-focus);
        box-shadow: 0 0 6px var(--input-focus);
    }
    
    /* Interactive Button Styles (Submit & Delete) */
    .submit-btn, .delete-btn {
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        border: none;
    }

    /* Submit button */
    .submit-btn {
        width: 95%;
        padding: 14px;
        margin-top: 15px;
        background: linear-gradient(135deg, var(--link-color), var(--link-hover-color));
        border-radius: 10px;
        font-size: 16px;
        color: #fff;
        box-shadow: 0 5px 10px rgba(0, 0, 0, 0.15);
    }
    .submit-btn:hover {
        background: linear-gradient(135deg, var(--link-hover-color), var(--link-color));
        transform: translateY(-3px) scale(1.02);
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.25);
    }
    
    /* --- REVISED SALARY SAVE BUTTON --- */
    .save-salary-btn {
        display: block;
        width: 150px; /* Small fixed width */
        margin: 15px auto 0 auto; /* Center button */
        padding: 10px 15px;
        background: var(--income-highlight);
        color: var(--bg-color-2);
        font-size: 0.9rem; /* Smaller font size */
        font-weight: 700;
        border-radius: 8px;
        transition: all 0.3s ease;
        text-transform: uppercase;
    }
    .save-salary-btn:hover {
        background: #e6b300;
        transform: scale(1.05);
    }
    /* ----------------------------------- */


    /* Delete button */
    .delete-btn {
        background: var(--delete-btn-bg);
        color: #fff;
        padding: 0.5rem 1rem;
        border-radius: 8px;
    }

    .delete-btn:hover {
        background: var(--delete-btn-hover);
        transform: scale(1.1);
        box-shadow: 0 0 10px var(--delete-btn-bg);
    }

    /* Table Styles */
    table {
        border-spacing: 0 0.5rem;
    }
    
    th {
        border-radius: 8px 8px 0 0;
        letter-spacing: 0.1em;
    }
    
    /* Expense Title, Amount, Date Column CENTERING */
    th, td {
        text-align: center;
        background: var(--table-bg); /* Transparent table rows */
        color: var(--text-color-light);
    }
    
    /* Left align the Title column for better readability */
    th:first-child, td:first-child {
        text-align: left;
    }

    /* ACTION column should not be centered if other columns are centered */
    th:last-child, td:last-child {
        text-align: center;
    }
    
    tr:last-child td {
        border-radius: 0 0 8px 8px;
    }
    
    td {
        padding: 0.8rem 1.5rem;
    }
    
    /* Styles for the Detail Report Button */
    .report-btn {
        display: block;
        width: 100%;
        margin-top: 30px;
        padding: 20px 0;
        text-decoration: none;
        text-align: center;
        font-size: 1.2rem;
        font-weight: 700;
        letter-spacing: 0.15em;
        border-radius: 10px;
        color: #fff;
        
        /* Prominent Gradient */
        background: linear-gradient(90deg, #ff9a8b 0%, #ff6a88 55%, #ff4c4c 100%); 
        box-shadow: 0 8px 20px rgba(255, 106, 136, 0.5);
        
        transition: all 0.3s ease;
    }

    .report-btn:hover {
        background: linear-gradient(90deg, #ff6a88 0%, #ff4c4c 55%, #ff9a8b 100%);
        transform: scale(1.02) translateY(-3px);
        box-shadow: 0 12px 25px rgba(255, 76, 76, 0.6);
    }
    
    /* Responsive adjustment for salary entry on small screens */
    @media (max-width: 600px) {
        .salary-row {
            flex-direction: column;
            gap: 0;
        }
        .salary-input, .salary-display {
            width: 100%; 
            margin-bottom: 10px;
        }
    }

  </style>
</head>
<body>
<div class="container">

    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <h2>MANAGE EXPENSES</h2>

    <div class="card">
        <h3>SALARY ENTRY</h3>
        <p style="font-size: 0.85rem; margin-top: -10px; margin-bottom: 20px;">
            <B>ENTER YOUR MONTHLY SALARY</B>
        </p>
        
        <form method="post" action="expenses.jsp">
            <input type="hidden" name="salaryAction" value="saveSalary" />
            
            <div class="salary-row">
                <input type="number" step="0.01" name="monthlySalary" class="salary-input"
                       placeholder="MONTHLY SALARY (RS)" 
                       value="<%= (monthlySalary > 0) ? String.format("%.2f", monthlySalary) : "" %>" required />
                
                <input type="text" class="salary-display" 
                       value="YEARLY: RS <%= String.format("%,.2f", yearlySalary) %>" 
                       readonly />
            </div>
                   
            <button type="submit" class="save-salary-btn">SAVE SALARY</button>
        </form>
    </div>

    <div class="card">
        <h3>ADD NEW EXPENSE</h3>
        <form method="post" action="expenses.jsp">
            <input type="hidden" name="action" value="add" />
            <input type="text" name="title" placeholder="Expense Title" required /><br>
            <input type="number" step="0.01" name="amount" placeholder="Amount (E.G., 45.99)" required /><br>
            <input type="date" name="date" required /><br>
            <input type="submit" value="ADD EXPENSE" class="submit-btn" />
        </form>
    </div>

    <div class="card">
        <h3>YOUR EXPENSES</h3>
        <% if(list.isEmpty()){ %>
            <p>NO EXPENSES FOUND.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th style="text-align: left;">TITLE</th> 
                        <th>AMOUNT</th>
                        <th>DATE</th>
                        <th>ACTION</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Expense e : list){ %>
                        <tr>
                            <td style="text-align: left;"><%= e.getTitle() %></td>
                            <td>RS <%= String.format("%,.2f", e.getAmount()) %></td>
                            <td><%= e.getDate() %></td>
                            <td>
                                <form method="post" action="expenses.jsp" 
                                      onsubmit="return confirm('ARE YOU SURE YOU WANT TO DELETE THIS EXPENSE?');">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="id" value="<%= e.getId() %>" />
                                    <input type="submit" value="DELETE" class="delete-btn" />
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <a href="expensechart.jsp" class="report-btn">DETAIL EXPENSE REPORT</a>
    </div>

</div>

</body>
</html>
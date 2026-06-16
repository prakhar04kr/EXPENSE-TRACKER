<%@ page import="dao.UserDao,model.user" %>
<%@ page session="true" %>

<%
if(request.getParameter("username") != null){
    user u = new user();
    u.setUsername(request.getParameter("username"));
    u.setEmail(request.getParameter("email"));
    u.setPassword(request.getParameter("password"));

    UserDao dao = new UserDao();
    if(dao.register(u)){
        response.sendRedirect("index.jsp?msg=registered");
        return;
    } else {
        request.setAttribute("error", "Registration failed! Try again.");
    }
}
%>

<html>
<head>
<title>Register | Expense Tracker</title>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;500;700&display=swap" rel="stylesheet">

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

    * { box-sizing: border-box; }

    body {
        margin: 0;
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        font-family: 'Montserrat', sans-serif;
        background: radial-gradient(circle at 30% 30%, #0f2027, #203a43, #2c5364);
        overflow: hidden;
        color: var(--text-color);
    }

    /* Animated background */
    .graph-bg {
        position: absolute;
        top: 0; left: 0;
        width: 100%; height: 100%;
        overflow: hidden;
        z-index: 0;
    }

    .graph-line {
        position: absolute;
        width: 200%; height: 100%;
        background: repeating-linear-gradient(
            to right,
            rgba(0,255,100,0.15) 0px,
            rgba(0,255,100,0.15) 2px,
            transparent 2px,
            transparent 40px
        );
        animation: slideLine 12s linear infinite;
        transform: rotate(-10deg);
    }

    @keyframes slideLine {
        from { transform: translateX(0) rotate(-10deg); }
        to { transform: translateX(-50%) rotate(-10deg); }
    }

    .pulse-dots {
        position: absolute;
        width: 100%; height: 100%;
        background: radial-gradient(circle, rgba(0,255,100,0.25) 2px, transparent 2px);
        background-size: 100px 100px;
        animation: pulse 6s ease-in-out infinite alternate;
        z-index: 0;
    }

    @keyframes pulse {
        from { opacity: 0.2; transform: scale(1); }
        to { opacity: 0.4; transform: scale(1.2); }
    }

    /* Register box styling */
    .register-box {
        position: relative;
        z-index: 2;
        background: var(--card-bg);
        backdrop-filter: blur(10px);
        border-radius: 16px;
        padding: 35px 40px;
        text-align: center;
        width: 550px;
        max-width: 95%;
        border: 2px solid var(--accent-blue);
        box-shadow: 0 0 40px rgba(0, 194, 255, 0.4);
        animation: fadeIn 1s ease-out;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: scale(0.9); }
        to { opacity: 1; transform: scale(1); }
    }

    h2 {
        margin-bottom: 25px;
        font-weight: 700;
        font-size: 28px;
        color: var(--accent-blue);
        text-shadow: 0 0 15px var(--accent-blue);
    }

    input[type=text], input[type=email], input[type=password] {
        width: 95%;
        padding: 14px;
        margin: 10px 0;
        border-radius: 10px;
        border: 2px solid var(--accent-blue);
        background: rgba(255,255,255,0.08);
        color: var(--text-color);
        font-size: 16px;
        transition: 0.35s ease;
        text-align: left;
        font-weight: 500;
    }

    input:focus {
        border-color: var(--accent-green);
        box-shadow: 0 0 15px var(--accent-green);
        outline: none;
        background: rgba(255,255,255,0.15);
    }

    input[type=submit], .btn {
        width: 95%;
        margin-top: 18px;
        padding: 13px 0;
        border-radius: 12px;
        border: none;
        background: linear-gradient(90deg, var(--accent-green), var(--accent-blue));
        font-size: 17px;
        font-weight: 700;
        color: var(--bg-color);
        cursor: pointer;
        transition: 0.3s ease;
        box-shadow: 0 0 15px rgba(0, 255, 136, 0.6);
        text-decoration: none;
        display: inline-block;
    }

    input[type=submit]:hover, .btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 0 25px var(--accent-green);
        background: linear-gradient(90deg, var(--accent-blue), var(--accent-green));
    }

    .error {
        margin-top: 15px;
        color: var(--accent-pink);
        font-weight: 600;
        text-shadow: 0 0 10px rgba(255,0,127,0.5);
    }

    p {
        margin-top: 20px;
        font-size: 15px;
        color: var(--text-color);
    }

    a {
        color: var(--accent-blue);
        text-decoration: none;
        font-weight: 600;
    }

    a:hover {
        color: var(--accent-green);
        text-decoration: underline;
    }

    @media (max-width: 500px) {
        .register-box {
            width: 90%;
            padding: 25px;
        }
    }
</style>
</head>
<body>

<div class="graph-bg">
    <div class="graph-line"></div>
    <div class="pulse-dots"></div>
</div>

<div class="register-box">
    <h2>REGISTER</h2>

    <form method="post">
        <input type="text" name="username" placeholder="ENTER USERNAME" required><br>
        <input type="email" name="email" placeholder="ENTER EMAIL" required><br>
        <input type="password" name="password" placeholder="ENTER PASSWORD" required><br>
        <input type="submit" value="REGISTER">
    </form>

    <div class="error">
        <%= (request.getAttribute("error") != null) ? request.getAttribute("error") : "" %>
    </div>

    <p>Already have an account? <a href="index.jsp">Login</a></p>
</div>

</body>
</html>

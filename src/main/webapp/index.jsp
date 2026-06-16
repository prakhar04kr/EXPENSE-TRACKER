<%@ page import="dao.UserDao,model.user" %>
<%@ page session="true" %>
<%
if(request.getParameter("username") != null){
    UserDao dao = new UserDao();
    user u = dao.login(request.getParameter("username"), request.getParameter("password"));
    if(u != null){
        session.setAttribute("user", u);
        response.sendRedirect("dashboard.jsp");
        return;
    } else {
        request.setAttribute("error", "Invalid username or password!");
    }
}
%>

<html>
<head>
<title>Expense Tracker Login</title>

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

    .graph-bg {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        overflow: hidden;
        z-index: 0;
    }

    .graph-line {
        position: absolute;
        width: 200%;
        height: 100%;
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
        width: 100%;
        height: 100%;
        background: radial-gradient(circle, rgba(0,255,100,0.25) 2px, transparent 2px);
        background-size: 100px 100px;
        animation: pulse 6s ease-in-out infinite alternate;
        z-index: 0;
    }

    @keyframes pulse {
        from { opacity: 0.2; transform: scale(1); }
        to { opacity: 0.4; transform: scale(1.2); }
    }

    .login-box {
        position: relative;
        z-index: 2;
        background: var(--card-bg);
        backdrop-filter: blur(10px);
        border-radius: 16px;
        padding: 50px 40px;
        text-align: center;
        width: 450px;
        max-width: 90%;
        border: 2px solid var(--accent-blue);
        box-shadow: 0 0 40px rgba(0, 194, 255, 0.4);
        animation: fadeIn 1s ease-out;
    }

    @keyframes fadeIn {
        from {opacity: 0; transform: scale(0.9);}
        to {opacity: 1; transform: scale(1);}
    }

    h2 {
        margin-bottom: 30px;
        font-weight: 700;
        font-size: 32px;
        text-shadow: 0 0 15px var(--accent-blue);
        color: var(--accent-blue);
    }
    
    .tracker-text {
        color: var(--accent-green);
        text-shadow: 0 0 10px var(--accent-green);
    }
    
    .login-text {
        color: var(--accent-blue);
        text-shadow: 0 0 10px var(--accent-blue);
    }

    input[type=text],
    input[type=password] {
        width: 95%;
        padding: 16px;
        margin: 14px 0;
        border-radius: 10px;
        border: 2px solid var(--accent-blue);
        background: rgba(255,255,255,0.08);
        color: var(--text-color);
        font-size: 16px;
        transition: 0.35s ease;
        text-align: left;
        font-weight: 500;
        letter-spacing: 0.5px;
    }

    input::placeholder {
        color: var(--text-color);
        opacity: 0.7;
    }

    input:focus {
        border-color: var(--accent-green);
        box-shadow: 0 0 15px var(--accent-green);
        outline: none;
        background: rgba(255,255,255,0.15);
    }

    input[type=submit] {
        width: 95%;
        margin-top: 25px;
        padding: 16px 0;
        border-radius: 12px;
        border: none;
        background: linear-gradient(90deg, var(--accent-green), var(--accent-blue)); 
        font-size: 18px;
        font-weight: 700;
        color: var(--bg-color);
        cursor: pointer;
        transition: 0.3s ease;
        box-shadow: 0 0 15px rgba(0, 255, 136, 0.6);
    }

    input[type=submit]:hover {
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
        margin-top: 25px;
        color: var(--text-color);
    }

    a {
        color: var(--accent-blue);
        text-decoration: none;
        font-weight: 700;
        transition: 0.3s;
    }
    a:hover { 
        text-decoration: underline; 
        color: var(--accent-green);
    }

    /* ✅ Visible Forgot Password Button */
    .forgot-btn {
        display: inline-block;
        margin-top: 20px;
        padding: 12px 30px;
        border-radius: 12px;
        background: var(--accent-yellow);
        color: #000; /* black text for visibility */
        font-weight: 700;
        text-transform: uppercase;
        font-size: 15px;
        transition: all 0.3s ease;
        border: none;
        box-shadow: none;
    }

    .forgot-btn:hover {
        transform: translateY(-3px);
        background: #ffeb3b;
        color: #000;
        opacity: 0.95;
    }

    @media (max-width: 500px) {
        .login-box { padding: 40px 20px; }
    }
</style>
</head>
<body>

<div class="graph-bg">
    <div class="graph-line"></div>
    <div class="pulse-dots"></div>
</div>

<div class="login-box">
    <h2>
        <span class="tracker-text">EXPENSE TRACKER</span> 
        <span class="login-text">LOGIN</span>
    </h2>

    <form method="post">
        <input type="text" name="username" placeholder="ENTER USERNAME" required>
        <input type="password" name="password" placeholder="ENTER PASSWORD" required>
        <input type="submit" value="LOGIN">
    </form>

    <div class="error"><%= (request.getAttribute("error") != null) ? request.getAttribute("error") : "" %></div>

    <p>DON'T HAVE AN ACCOUNT? <a href="register.jsp">REGISTER</a></p>

    <!-- ✅ Bright, visible button -->
    <a href="forget.jsp" class="forgot-btn">FORGOT PASSWORD?</a>
</div>

</body>
</html>

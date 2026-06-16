<%@ page import="model.user" %>
<%@ page session="true" %>
<%
    // 1. Retrieve the user object and username before session invalidation
    String username = "";
    user user = (user) session.getAttribute("user");
    if (user != null) {
        // Convert to uppercase here to ensure it's capitalized
        username = user.getUsername().toUpperCase();
    }
    
    // 2. Invalidate the session
    session.invalidate();
%>
<html>
<head>
  <title>Logout</title>
  <!-- Use the modern font from the dashboard -->
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;500;600;700&display=swap" rel="stylesheet">
  <style>
    /* Color variables from expenses.jsp for consistency */
    :root {
        --bg-color-2: #264653; /* Dark Blue/Green */
        --link-color: #48cae4; /* Light Blue */
        --link-hover-color: #0077b6; /* Darker Blue */
    }

    body {
        font-family: 'Montserrat', sans-serif;
        /* ALL TEXT IN CAPS */
        text-transform: uppercase; 
        
        /* UPDATED BACKGROUND IMAGE */
        background: url('https://www.moneypatrol.com/moneytalk/wp-content/uploads/2023/06/budget185.png') no-repeat center center fixed;
        background-size: cover;
        
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
        color: white;
        position: relative;
    }
    
    /* Dark overlay for readability */
    body::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.55);
        z-index: -1;
    }

    .container {
        /* Themed dark background with blur */
        background: rgba(38, 70, 83, 0.9); /* var(--bg-color-2) semi-transparent */
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.3);
        border-radius: 12px;
        padding: 40px;
        box-shadow: 0 10px 40px rgba(72, 202, 228, 0.3); /* Blue shadow glow */
        text-align: center;
        width: 350px;
        color: white;
    }

    h2 { 
        color: #fff; 
        font-weight: 700;
        letter-spacing: 1px;
        margin-bottom: 25px;
    }
    
    .logout-message {
        font-size: 18px;
        font-weight: 500;
        color: #cceeff; /* Light blue text */
        display: block;
        margin-bottom: 15px;
    }
    
    .username-thank {
        font-size: 24px;
        font-weight: 700;
        color: var(--link-color);
        text-shadow: 0 0 10px var(--link-color);
        display: block;
        margin-bottom: 5px;
    }

    /* Interactive Button Styling */
    a {
        text-decoration: none;
        background: linear-gradient(135deg, var(--link-color), var(--link-hover-color));
        color: white;
        padding: 12px 24px;
        border-radius: 8px;
        display: inline-block;
        margin-top: 20px;
        font-weight: 600;
        letter-spacing: 0.5px;
        transition: all 0.3s ease;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.4);
    }

    a:hover { 
        background: linear-gradient(135deg, var(--link-hover-color), var(--link-color));
        transform: translateY(-3px) scale(1.05);
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.6);
    }
  </style>
</head>
<body>
  <div class="container">
    <span class="username-thank">THANKS, <%= username %></span>
    <h2 class="logout-message">YOU HAVE SUCCESSFULLY LOGGED OUT.</h2>
    <a href="index.jsp">LOGIN AGAIN</a>
  </div>
</body>
</html>
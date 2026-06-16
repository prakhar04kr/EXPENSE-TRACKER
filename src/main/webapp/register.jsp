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
  <title>Register</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    /* Background animation */
    body {
      margin: 0;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      background: linear-gradient(135deg, #1e3c72, #2a5298);
      font-family: "Poppins", sans-serif;
      color: #fff;
      overflow: hidden;
      animation: gradientMove 10s ease infinite alternate;
    }

    @keyframes gradientMove {
      0% { background: linear-gradient(135deg, #1e3c72, #2a5298); }
      100% { background: linear-gradient(135deg, #2a5298, #1e3c72); }
    }

    /* Register box */
    .register-container {
      background: rgba(255, 255, 255, 0.12);
      backdrop-filter: blur(14px);
      border-radius: 20px;
      box-shadow: 0 0 25px rgba(255, 255, 255, 0.1);
      width: 90%;
      max-width: 400px;
      padding: 40px 30px;
      text-align: center;
      animation: fadeInUp 0.8s ease forwards;
      transform: translateY(30px);
      opacity: 0;
    }

    @keyframes fadeInUp {
      to {
        transform: translateY(0);
        opacity: 1;
      }
    }

    h2 {
      font-size: 1.9em;
      margin-bottom: 20px;
      font-weight: 700;
      color: #f8f9fa;
      letter-spacing: 1px;
    }

    input[type=text],
    input[type=email],
    input[type=password] {
      width: 100%;
      padding: 14px 12px;
      margin: 10px 0;
      border: none;
      border-radius: 12px;
      font-size: 16px;
      background: rgba(255, 255, 255, 0.15);
      color: #fff;
      outline: none;
      transition: all 0.3s ease;
    }

    input::placeholder {
      color: #e0e0e0;
    }

    input:focus {
      background: rgba(255, 255, 255, 0.25);
      box-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
      transform: scale(1.02);
    }

    input[type=submit] {
      width: 100%;
      margin-top: 10px;
      padding: 14px;
      border: none;
      border-radius: 12px;
      font-size: 18px;
      font-weight: 600;
      color: #fff;
      background: linear-gradient(135deg, #00b4d8, #0077b6);
      cursor: pointer;
      box-shadow: 0 0 15px #00b4d8aa;
      transition: all 0.3s ease;
    }

    input[type=submit]:hover {
      background: linear-gradient(135deg, #0077b6, #00b4d8);
      box-shadow: 0 0 20px #90e0ef;
      transform: translateY(-3px);
    }

    p {
      margin-top: 15px;
      color: #e0e0e0;
      font-size: 15px;
    }

    a {
      color: #00b4d8;
      font-weight: 600;
      text-decoration: none;
      transition: color 0.3s;
    }

    a:hover {
      color: #90e0ef;
      text-shadow: 0 0 6px #00b4d8;
    }

    .error {
      background: rgba(255, 0, 0, 0.2);
      color: #ffb3b3;
      padding: 10px 15px;
      border-radius: 10px;
      margin-bottom: 10px;
      font-weight: 600;
      display: inline-block;
      box-shadow: 0 0 10px rgba(255, 0, 0, 0.3);
    }

    /* Responsive scaling for all devices */
    @media (max-width: 600px) {
      .register-container {
        padding: 30px 20px;
        width: 90%;
      }
      h2 {
        font-size: 1.6em;
      }
      input[type=text],
      input[type=email],
      input[type=password],
      input[type=submit] {
        font-size: 15px;
        padding: 12px 10px;
      }
    }

    @media (max-width: 400px) {
      h2 {
        font-size: 1.4em;
      }
      .register-container {
        border-radius: 15px;
        padding: 25px 18px;
      }
    }

  </style>
</head>
<body>
  <div class="register-container">
    <h2>Create Account</h2>
    <form method="post">
      <input type="text" name="username" placeholder="Enter Username" required><br>
      <input type="email" name="email" placeholder="Enter Email" required><br>
      <input type="password" name="password" placeholder="Enter Password" required><br>
      <input type="submit" value="Register">
    </form>

    <div class="error">
      <%= (request.getAttribute("error") != null) ? request.getAttribute("error") : "" %>
    </div>

    <p>Already have an account? <a href="index.jsp">Back to Login</a></p>
  </div>
</body>
</html>

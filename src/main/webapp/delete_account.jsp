<%@ page import="dao.UserDao,model.user" %>
<%@ page session="true" %>
<%
user user = (user)session.getAttribute("user");
if(user == null){
    response.sendRedirect("index.jsp");
    return;
}
%>
<html>
<head>
  <title>Delete Account</title>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;500;600;700&display=swap" rel="stylesheet">
  <style>
    /* Color variables from expenses.jsp for consistency */
    :root {
        --bg-color-2: #264653; /* Dark Blue/Green */
        --link-color: #48cae4; /* Light Blue */
        --link-hover-color: #0077b6; /* Darker Blue */
        --delete-btn-bg: #ff4c4c;
        --delete-btn-hover: #d43232;
    }

    /* NEW: Video Background Styling 
    */
    #video-background {
        position: fixed;
        right: 0;
        bottom: 0;
        min-width: 100%;
        min-height: 100%;
        width: auto;
        height: auto;
        z-index: -2; /* Placed behind the overlay */
        object-fit: cover; /* Ensures the video covers the entire screen */
        filter: brightness(0.65) contrast(1.1); /* Slightly darken and enhance video contrast */
    }

    body {
        font-family: 'Montserrat', sans-serif;
        /* ALL TEXT IN CAPS */
        text-transform: uppercase; 
        
        /* REMOVED STATIC BACKGROUND */
        
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
        color: white;
        position: relative;
    }
    
    /* Dark overlay for readability (Z-index changed to -1 to sit over the video) */
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
        /* Themed dark background with blur (matching expenses.jsp card style) */
        background: rgba(38, 70, 83, 0.9); /* var(--bg-color-2) semi-transparent */
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.3);
        border-radius: 12px;
        padding: 40px;
        box-shadow: 0 10px 40px rgba(255, 76, 76, 0.4); /* Red shadow glow */
        width: 400px;
        text-align: center;
        color: white;
        position: relative; /* Ensure container stays above video/overlay */
        z-index: 1;
    }

    h2 { 
        color: var(--delete-btn-bg); /* Red heading */
        font-weight: 700; 
        letter-spacing: 1px;
        margin-bottom: 25px;
    }
    
    p {
        font-weight: 500;
        font-size: 16px;
        margin-bottom: 20px;
    }

    .delete-message {
        color: #ffcccc; /* Light red for the confirmation text */
        margin-top: 15px;
        margin-bottom: 25px;
        font-weight: 600;
        line-height: 1.5;
    }
    
    .username-bold {
        color: #fff;
        font-weight: 700;
        font-size: 18px;
    }
    
    form { 
        margin-top: 20px; 
    }

    /* Delete Button (Primary Action) */
    input[type="submit"] {
        background: var(--delete-btn-bg);
        border: none;
        color: white;
        padding: 12px 24px;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        letter-spacing: 0.5px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 10px rgba(255, 0, 0, 0.4);
    }
    input[type="submit"]:hover { 
        background: var(--delete-btn-hover); 
        transform: translateY(-3px) scale(1.05);
        box-shadow: 0 8px 15px rgba(255, 0, 0, 0.6);
    }
    
    /* Cancel Button (Secondary Action) */
    .cancel-btn {
        display: inline-block;
        margin-top: 20px;
        text-decoration: none;
        background: var(--bg-color-2); /* Use the dark card color */
        color: white;
        padding: 10px 20px;
        border-radius: 8px;
        font-weight: 600;
        letter-spacing: 0.5px;
        transition: all 0.3s ease;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
        border: 1px solid rgba(255, 255, 255, 0.2);
    }
    .cancel-btn:hover { 
        background: #3a7a93; 
        transform: translateY(-2px);
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.4);
    }
    
    /* Message styling for runtime output */
    .runtime-message {
        padding: 10px;
        border-radius: 8px;
        margin-top: 20px;
        font-weight: 600;
    }
    .runtime-message.success {
        color: #1e7d3e; /* Dark green text */
        background: #d4edda; /* Light green background */
    }
    .runtime-message.failure {
        color: #842029; /* Dark red text */
        background: #f8d7da; /* Light red background */
    }
    .runtime-message a {
        color: var(--link-color);
        text-decoration: underline;
        margin-top: 0;
        display: inline;
        background: none;
        padding: 0;
        box-shadow: none;
        transition: color 0.2s;
    }
    .runtime-message a:hover {
        color: var(--link-hover-color);
        transform: none;
    }

  </style>
</head>
<body>
  
  <video autoplay muted loop id="video-background">
      <source src="https://v.ftcdn.net/02/68/67/80/700_F_268678046_5SiGHoAIfmzt82xlrFsGjJmeiYy9zVYu_ST.mp4" type="video/mp4">
      Your browser does not support the video tag.
  </video>
  <div class="container">
    <h2>DELETE ACCOUNT</h2>
    
    <div class="delete-message">
        <p>
            SORRY TO SEE YOU GO.<BR>
            ARE YOU SURE YOU WANT TO DELETE YOUR ACCOUNT, 
            <span class="username-bold"><%= user.getUsername().toUpperCase() %></span>?
        </p>
    </div>
    

    <form method="post">
      <input type="submit" name="delete" value="YES, DELETE MY ACCOUNT">
    </form>
    <a href="dashboard.jsp" class="cancel-btn">CANCEL</a>

<%
if(request.getParameter("delete") != null){
    UserDao dao = new UserDao();
    
    String messageStyle = "";
    String messageText = "";

    if(dao.delete(user.getId())){
        session.invalidate();
        messageStyle = "success";
        messageText = "ACCOUNT DELETED SUCCESSFULLY. <a href='index.jsp'>GO TO HOME</a>";
    } else {
        messageStyle = "failure";
        messageText = "FAILED TO DELETE ACCOUNT.";
    }
    
    out.println("<div class='runtime-message " + messageStyle + "'>" + messageText + "</div>");
}
%>
  </div>
</body>
</html>
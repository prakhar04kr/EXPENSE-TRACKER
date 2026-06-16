<%@ page import="model.user" %>
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
<title>Dashboard</title>

<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;500;600;700&display=swap" rel="stylesheet">

<style>
    :root {
        --light-card-bg: rgba(240, 240, 240, 0.2);
        --dark-card-bg: rgba(22, 27, 34, 0.7);
        --accent-green: #00ff99;
        --accent-blue: #00c2ff;
        --text-color-dark: #0d1117;
    }

    * {
        box-sizing: border-box;
    }

    body {
        font-family: 'Montserrat', sans-serif;
        margin: 0;
        padding: 0;
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        color: white;
        background: black;
        position: relative;
        overflow: hidden;
    }

    video.bg-video {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        z-index: -1;
    }

    .overlay {
        position: absolute;
        inset: 0;
        background: rgba(0, 0, 0, 0.65);
        z-index: 0;
    }

    .container {
        position: relative;
        z-index: 1;
        background: var(--light-card-bg);
        backdrop-filter: blur(10px);
        border-radius: 20px;
        padding: 3.5rem 5rem;
        text-align: center;
        box-shadow: 0 0 25px rgba(0, 0, 0, 0.6);
        animation: fadeIn .8s ease-out;
        width: 95%;
        max-width: 700px; /* Wider container */
        border: 2px solid var(--accent-green);
        transition: background 0.4s ease, box-shadow 0.4s ease, transform 0.3s ease;
    }

    .container:hover {
        background: var(--dark-card-bg);
        box-shadow: 0 0 40px rgba(0, 255, 153, 0.6);
        transform: scale(1.02);
    }

    @keyframes fadeIn {
        from {opacity: 0; transform: scale(.9);}
        to {opacity: 1; transform: scale(1);}
    }

    h2 {
        font-weight: 700;
        margin-bottom: 2.5rem;
        letter-spacing: 1px;
        color: var(--accent-green);
        text-shadow: 0 0 8px rgba(0, 255, 153, 0.7);
        font-size: clamp(1.6rem, 4vw, 2.4rem);
        word-break: break-word;
    }

    ul {
        list-style: none;
        padding: 0;
        margin: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 1.2rem;
    }

    .btn {
        display: inline-block;
        width: 100%;
        max-width: 500px; /* Wider button */
        padding: 18px 30px; /* Space before and after text */
        font-size: clamp(1rem, 2vw, 1.2rem);
        font-weight: 600;
        letter-spacing: 1px;
        text-transform: uppercase;
        color: var(--text-color-dark);
        text-decoration: none;
        border-radius: 14px;
        border: none;
        background: linear-gradient(135deg, var(--accent-green), var(--accent-blue));
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        box-shadow: 0 8px 18px rgba(0, 0, 0, 0.5);
        text-align: center;
    }

    .btn:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 25px rgba(0, 255, 120, 0.5);
        letter-spacing: 1.2px;
    }

    .delete {
        background: linear-gradient(135deg, #ff4d4f, #cc0000);
        color: #fff;
    }

    .delete:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 25px rgba(255, 0, 0, 0.5);
        letter-spacing: 1.2px;
    }

    @media (max-width: 768px) {
        .container {
            padding: 2.5rem 2rem;
            max-width: 90%;
        }

        .btn {
            max-width: 100%;
            padding: 16px 25px;
        }
    }

    @media (max-width: 480px) {
        .container {
            padding: 2rem 1.5rem;
            width: 90%;
            border-radius: 15px;
        }

        .btn {
            padding: 14px 20px;
            font-size: 0.95rem;
        }

        ul li {
            margin: 0.4rem 0;
        }
    }
</style>
</head>

<body>

<video class="bg-video" autoplay muted loop>
    <source src="https://v.ftcdn.net/02/68/67/80/700_F_268678046_5SiGHoAIfmzt82xlrFsGjJmeiYy9zVYu_ST.mp4" type="video/mp4">
</video>

<div class="overlay"></div>

<div class="container">
    <h2>WELCOME, <%= user.getUsername().toUpperCase() %></h2>

    <ul>
        <li><a class="btn" href="expenses.jsp">   MANAGE EXPENSES   </a></li>
        <li><a class="btn" href="profile.jsp">   UPDATE PROFILE   </a></li>
        <li><a class="btn" href="logout.jsp">   LOGOUT   </a></li>
        <li><a class="btn delete" href="delete_account.jsp">   DELETE ACCOUNT   </a></li>
    </ul>
</div>

</body>
</html>

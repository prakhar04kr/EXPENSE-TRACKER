<%@ page import="model.user" %>
<%@ page session="true" %>
<%
user user = (user)session.getAttribute("user");
if (user == null) {
    response.sendRedirect("index.jsp");
}
String success = request.getParameter("success"); // check if redirected after update
%>

<html>
<head>
<title>Update Profile</title>

<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;500;600;700&display=swap" rel="stylesheet">

<style>
    :root {
        --light-card-bg: rgba(240, 240, 240, 0.2);
        --dark-card-bg: rgba(22, 27, 34, 0.7);
        --accent-green: #00ff99;
        --accent-blue: #00c2ff;
        --text-color-dark: #0d1117;
    }

    * { box-sizing: border-box; }

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
        padding: 3rem 4rem;
        text-align: center;
        box-shadow: 0 0 25px rgba(0, 0, 0, 0.6);
        width: min(90%, 600px);
        border: 2px solid var(--accent-green);
        transition: background 0.4s ease, box-shadow 0.4s ease;
    }

    .container:hover {
        background: var(--dark-card-bg);
        box-shadow: 0 0 35px rgba(0, 255, 153, 0.6);
    }

    h2 {
        color: var(--accent-green);
        text-shadow: 0 0 8px rgba(0, 255, 153, 0.7);
        margin-bottom: 1.8rem;
        font-weight: 700;
        font-size: clamp(1.6rem, 4vw, 2.3rem);
    }

    form {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 1.2rem;
        width: 100%;
    }

    input {
        width: 100%;
        max-width: 420px;
        padding: 14px 22px;
        font-size: 1rem;
        border-radius: 10px;
        border: none;
        outline: none;
        background: rgba(255, 255, 255, 0.85);
        color: #000;
        transition: all 0.3s ease;
    }

    input:focus {
        box-shadow: 0 0 10px var(--accent-green);
        transform: scale(1.02);
    }

    .btn {
        width: 100%;
        max-width: 420px;
        padding: 16px;
        font-size: 1rem;
        font-weight: 600;
        text-transform: uppercase;
        color: var(--text-color-dark);
        border: none;
        border-radius: 10px;
        background: linear-gradient(135deg, var(--accent-green), var(--accent-blue));
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.5);
    }

    .btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 12px 25px rgba(0, 255, 120, 0.5);
        letter-spacing: 1px;
    }

    /* ✅ Top Navigation Buttons */
    .nav-buttons {
        position: absolute;
        top: 25px;
        right: 30px;
        display: flex;
        gap: 12px;
        z-index: 5;
    }

    .nav-btn {
        padding: 10px 18px;
        border-radius: 8px;
        border: none;
        font-size: 0.95rem;
        font-weight: 600;
        cursor: pointer;
        background: linear-gradient(135deg, var(--accent-green), var(--accent-blue));
        color: var(--text-color-dark);
        box-shadow: 0 4px 12px rgba(0,0,0,0.4);
        transition: all 0.3s ease;
    }

    .nav-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(0,255,150,0.5);
        letter-spacing: 0.5px;
    }

    /* ✅ Success Box */
    .success-box {
        position: fixed;
        bottom: 40px;
        left: 50%;
        transform: translateX(-50%) translateY(120%);
        background: rgba(255, 255, 255, 0.96);
        color: #000;
        padding: 1.5rem 2.5rem;
        border-radius: 15px;
        text-align: center;
        box-shadow: 0 0 25px rgba(0, 255, 120, 0.4);
        z-index: 10;
        min-width: 280px;
        width: min(90%, 400px);
        animation: slideUp 0.6s ease-out forwards;
    }

    @keyframes slideUp {
        from { transform: translateX(-50%) translateY(120%); opacity: 0; }
        to { transform: translateX(-50%) translateY(0); opacity: 1; }
    }

    @keyframes slideDown {
        from { transform: translateX(-50%) translateY(0); opacity: 1; }
        to { transform: translateX(-50%) translateY(120%); opacity: 0; }
    }

    .success-box h3 {
        margin: 0;
        font-size: 1.1rem;
        color: #009933;
        font-weight: 600;
    }

    .close-btn {
        position: absolute;
        top: 8px;
        right: 12px;
        background: none;
        border: none;
        font-size: 18px;
        cursor: pointer;
        color: #444;
        transition: color 0.3s;
    }

    .close-btn:hover {
        color: red;
    }

    @media (max-width: 600px) {
        .container {
            padding: 2.5rem 1.5rem;
        }

        input, .btn {
            max-width: 100%;
        }

        .success-box {
            bottom: 20px;
            width: 90%;
            padding: 1.2rem;
        }

        .nav-buttons {
            top: 15px;
            right: 15px;
        }

        .nav-btn {
            padding: 8px 14px;
            font-size: 0.9rem;
        }
    }
</style>
</head>

<body>

<!-- ✅ Background Video -->
<video class="bg-video" autoplay muted loop>
    <source src="https://v.ftcdn.net/02/68/67/80/700_F_268678046_5SiGHoAIfmzt82xlrFsGjJmeiYy9zVYu_ST.mp4" type="video/mp4">
</video>

<div class="overlay"></div>

<!-- ✅ Home + Logout Buttons -->
<div class="nav-buttons">
    <button class="nav-btn" onclick="window.location.href='dashboard.jsp'">Home</button>
    <button class="nav-btn" onclick="window.location.href='logout.jsp'">Logout</button>
</div>

<div class="container">
    <h2>UPDATE PROFILE</h2>

    <form action="updateProfileServlet" method="post">
        <input type="text" name="username" value="<%= user.getUsername() %>" placeholder="Enter New Username" required>
        <input type="email" name="email" value="<%= user.getEmail() %>" placeholder="Enter New Email" required>
        <input type="password" name="password" placeholder="Enter New Password" required>
        <button type="submit" class="btn">UPDATE PROFILE</button>
    </form>
</div>

<% if ("true".equals(success)) { %>
<div class="success-box" id="successBox">
    <button class="close-btn" onclick="closeBox()">×</button>
    <h3>Profile updated successfully!</h3>
</div>

<script>
    function closeBox() {
        const box = document.getElementById("successBox");
        box.style.animation = "slideDown 0.6s ease-in forwards";
        setTimeout(() => {
            window.location.href = "dashboard.jsp";
        }, 700);
    }

    // Auto close after 30 seconds and redirect
    setTimeout(() => {
        closeBox();
    }, 30000);
</script>
<% } %>

</body>
</html>

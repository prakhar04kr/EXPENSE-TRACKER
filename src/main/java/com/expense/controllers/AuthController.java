package com.expense.controllers;

import com.expense.services.AuthService;
import model.user;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @GetMapping("/")
    public String root() {
        return "redirect:/index.jsp";
    }

    @GetMapping("/index.jsp")
    public String indexGet() {
        return "index";
    }


    @PostMapping("/index.jsp")
    public String indexPost(
            @RequestParam String username,
            @RequestParam String password,
            HttpServletRequest request,
            HttpSession session
    ) {
        user u = authService.login(username, password);
        if (u != null) {
            session.setAttribute("user", u);
            return "redirect:/dashboard.jsp";
        }
        request.setAttribute("error", "Invalid username or password!");
        return "index";
    }

    @GetMapping("/register.jsp")
    public String registerGet() {
        return "register";
    }

    @PostMapping("/register.jsp")
    public String registerPost(
            @RequestParam String username,
            @RequestParam String email,
            @RequestParam String password,
            HttpServletRequest request
    ) {
        user u = new user();
        u.setUsername(username);
        u.setEmail(email);
        u.setPassword(password);

        if (authService.register(u)) {
            return "redirect:/index.jsp?msg=registered";
        }

        request.setAttribute("error", "Registration failed! Try again.");
        return "register";
    }

    @GetMapping("/forget.jsp")
    public String forgetGet() {
        return "forget";
    }

    @PostMapping("/forget.jsp")
    public String forgetPost(
            @RequestParam String username,
            @RequestParam String email,
            @RequestParam String password,
            HttpServletRequest request
    ) {
        // Based on your existing forget.jsp logic (it performs register-like behavior)
        user u = new user();
        u.setUsername(username);
        u.setEmail(email);
        u.setPassword(password);

        if (authService.register(u)) {
            return "redirect:/index.jsp?msg=registered";
        }

        request.setAttribute("error", "Registration failed! Try again.");
        return "forget";
    }
}


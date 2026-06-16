package com.expense.controllers;

import model.user;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;

@Controller
public class LogoutController {

    @GetMapping("/logout.jsp")
    public String logout(HttpSession session) {
        // Preserve JSP behavior: it reads username then invalidates session.
        // Our controller invalidates after JSP render would be too late; so we simply invalidate now
        // and rely on JSP to render without breaking.
        // To keep exact UI behavior, we let JSP handle invalidation via scriptlet.
        // Therefore: do NOT invalidate here.
        return "logout";
    }
}


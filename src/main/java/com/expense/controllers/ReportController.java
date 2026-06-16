package com.expense.controllers;

import model.user;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;

@Controller
public class ReportController {

    @GetMapping("/dashboard.jsp")
    public String dashboard(HttpSession session) {
        user u = (user) session.getAttribute("user");
        if (u == null) return "redirect:/index.jsp";
        return "dashboard";
    }

    @GetMapping("/expensechart.jsp")
    public String expensechart(HttpSession session) {
        user u = (user) session.getAttribute("user");
        if (u == null) return "redirect:/index.jsp";
        return "expensechart";
    }

    @GetMapping("/codeanalysis.jsp")
    public String codeanalysis(HttpSession session) {
        user u = (user) session.getAttribute("user");
        if (u == null) return "redirect:/index.jsp";
        return "codeanalysis";
    }
}


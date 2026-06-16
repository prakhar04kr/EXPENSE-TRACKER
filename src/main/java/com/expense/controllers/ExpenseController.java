package com.expense.controllers;

import com.expense.services.ExpenseService;
import com.expense.services.SalaryService;
import model.Expense;
import model.user;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.sql.Date;

@Controller
public class ExpenseController {

    private final ExpenseService expenseService;
    private final SalaryService salaryService;

    public ExpenseController(ExpenseService expenseService, SalaryService salaryService) {
        this.expenseService = expenseService;
        this.salaryService = salaryService;
    }

    @GetMapping("/expenses.jsp")
    public String expensesGet(HttpSession session) {
        user user = (user) session.getAttribute("user");
        if (user == null) {
            return "redirect:/index.jsp";
        }
        // JSP expects scriptlet variables; our approach is to keep JSP logic intact.
        // Controller does not calculate list; JSP will call DAOs unless we refactor.
        // Minimal compatibility layer: expose nothing extra.
        return "expenses";
    }

    @PostMapping("/expenses.jsp")
    public String expensesPost(HttpServletRequest request, HttpSession session) {
        user user = (user) session.getAttribute("user");
        if (user == null) {
            return "redirect:/index.jsp";
        }

        String salaryAction = request.getParameter("salaryAction");
        String monthlySalaryStr = request.getParameter("monthlySalary");
        salaryService.handleSalarySave(salaryAction, monthlySalaryStr, session);

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String title = request.getParameter("title");
            String amountStr = request.getParameter("amount");
            String dateStr = request.getParameter("date");
            try {
                if (title != null && !title.trim().isEmpty() && amountStr != null && dateStr != null) {
                    double amount = Double.parseDouble(amountStr);
                    if (amount >= 0) {
                        Expense exp = new Expense();
                        exp.setUserId(user.getId());
                        exp.setTitle(title.trim());
                        exp.setAmount(amount);
                        exp.setDate(Date.valueOf(dateStr));
                        expenseService.addExpense(exp);
                    }
                }
            } catch (Exception ignored) {
            }
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    expenseService.deleteExpense(id, user.getId());
                } catch (Exception ignored) {
                }
            }
        }

        return "redirect:/expenses.jsp";
    }
}


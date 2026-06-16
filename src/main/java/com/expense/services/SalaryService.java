package com.expense.services;

import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpSession;

@Service
public class SalaryService {

    public void handleSalarySave(String salaryAction, String monthlySalaryStr, HttpSession session) {
        if (salaryAction == null || monthlySalaryStr == null) return;
        if (!"saveSalary".equals(salaryAction)) return;

        try {
            double newMonthlySalary = Double.parseDouble(monthlySalaryStr);
            if (newMonthlySalary >= 0) {
                session.setAttribute("monthlySalary", newMonthlySalary);
            }
        } catch (NumberFormatException ignored) {
        }
    }
}


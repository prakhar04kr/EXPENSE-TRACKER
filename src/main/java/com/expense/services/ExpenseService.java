package com.expense.services;

import dao.ExpenseDAO;
import model.Expense;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ExpenseService {

    private final ExpenseDAO expenseDAO;

    public ExpenseService() {
        this.expenseDAO = new ExpenseDAO();
    }

    public boolean addExpense(Expense exp) {
        return expenseDAO.addExpense(exp);
    }

    public boolean deleteExpense(int id, int userId) {
        return expenseDAO.deleteExpense(id, userId);
    }

    public List<Expense> getExpensesByUser(int userId) {
        return expenseDAO.getExpensesByUser(userId);
    }
}


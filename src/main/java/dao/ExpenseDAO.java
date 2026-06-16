package dao;

import model.Expense;
import util.DBConnection;
import java.sql.*;
import java.util.*;

public class ExpenseDAO {

    public boolean addExpense(Expense exp) {
        String sql = "INSERT INTO expenses(user_id,title,amount,date) VALUES(?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, exp.getUserId());
            ps.setString(2, exp.getTitle());
            ps.setDouble(3, exp.getAmount());
            ps.setDate(4, exp.getDate());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public List<Expense> getExpensesByUser(int userId) {
        List<Expense> list = new ArrayList<>();
        String sql = "SELECT * FROM expenses WHERE user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Expense e = new Expense();
                e.setId(rs.getInt("id"));
                e.setUserId(rs.getInt("user_id"));
                e.setTitle(rs.getString("title"));
                e.setAmount(rs.getDouble("amount"));
                e.setDate(rs.getDate("date"));
                list.add(e);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    public boolean deleteExpense(int id, int userId) {
        String sql = "DELETE FROM expenses WHERE id=? AND user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

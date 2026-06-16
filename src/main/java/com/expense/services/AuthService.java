package com.expense.services;

import dao.UserDao;
import model.user;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserDao userDao;

    public AuthService() {
        this.userDao = new UserDao();
    }

    public user login(String username, String password) {
        return userDao.login(username, password);
    }

    public boolean register(user u) {
        return userDao.register(u);
    }

    public boolean deleteUser(int id) {
        return userDao.delete(id);
    }

    public boolean updateUser(user u) {
        return userDao.updateUser(u);
    }
}


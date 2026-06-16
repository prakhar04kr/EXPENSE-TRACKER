package com.expense.services;

import dao.UserDao;
import model.user;
import org.springframework.stereotype.Service;

@Service
public class ProfileService {

    private final UserDao userDao;

    public ProfileService() {
        this.userDao = new UserDao();
    }

    public boolean updateUser(user u) {
        return userDao.updateUser(u);
    }

    public boolean deleteUser(int id) {
        return userDao.delete(id);
    }
}


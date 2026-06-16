package com.expense.controllers;

import com.expense.services.ProfileService;
import model.user;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class ProfileController {

    private final ProfileService profileService;

    public ProfileController(ProfileService profileService) {
        this.profileService = profileService;
    }

    @GetMapping("/profile.jsp")
    public String profile(HttpSession session) {
        user u = (user) session.getAttribute("user");
        if (u == null) return "redirect:/index.jsp";
        return "profile";
    }

    @PostMapping("/updateProfileServlet")
    public String updateProfile(
            @RequestParam String username,
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session
    ) {
        user u = (user) session.getAttribute("user");
        if (u == null) return "redirect:/index.jsp";

        u.setUsername(username);
        u.setEmail(email);
        u.setPassword(password);

        profileService.updateUser(u);
        session.setAttribute("user", u);

        return "redirect:/profile.jsp?success=true";
    }

    @GetMapping("/delete_account.jsp")
    public String deleteAccount(HttpSession session) {
        user u = (user) session.getAttribute("user");
        if (u == null) return "redirect:/index.jsp";
        return "delete_account";
    }

    @PostMapping("/delete_account.jsp")
    public String deleteAccountPost(HttpSession session, HttpServletRequest request) {
        user u = (user) session.getAttribute("user");
        if (u == null) return "redirect:/index.jsp";

        String del = request.getParameter("delete");
        if (del != null) {
            profileService.deleteUser(u.getId());
            session.invalidate();
            return "redirect:/index.jsp";
        }

        return "delete_account";
    }
}


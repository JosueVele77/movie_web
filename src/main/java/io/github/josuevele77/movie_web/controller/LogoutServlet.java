package io.github.josuevele77.movie_web.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", value = "/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtenemos la sesión actual, pero sin crear una nueva (por eso va "false")
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Esto destruye absolutamente todos los datos (incluido el usuarioLogueado)
            session.invalidate();
        }

        // Redirigimos al usuario a la pantalla de Login después de borrar su sesión
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    }
}
package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Consultar las métricas usando el DAO
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        int totalClientes = usuarioDAO.contarClientes();

        // 2. Enviar los datos del contador al JSP como un atributo
        request.setAttribute("totalClientes", totalClientes);

        // 3. Redirección interna hacia el archivo JSP
        request.getRequestDispatcher("/pages/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
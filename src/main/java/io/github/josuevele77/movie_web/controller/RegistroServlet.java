package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.UsuarioDAO;
import io.github.josuevele77.movie_web.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario u = new Usuario();
        u.setNombreUs(request.getParameter("nombre"));
        u.setCedulaUs(request.getParameter("cedula"));
        u.setCorreoUs(request.getParameter("correo"));
        u.setClaveUs(request.getParameter("clave"));

        // Recibe el ID numérico del Combo Box seleccionado
        u.setIdEst(Integer.parseInt(request.getParameter("id_est")));

        UsuarioDAO dao = new UsuarioDAO();
        if (dao.registrar(u)) {
            response.sendRedirect("pages/login.jsp?success=Registrado");
        } else {
            response.sendRedirect("pages/registro.jsp?error=ErrorGuardar");
        }
    }
}
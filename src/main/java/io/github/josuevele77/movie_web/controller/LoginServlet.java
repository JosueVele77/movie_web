package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.UsuarioDAO;
import io.github.josuevele77.movie_web.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");

        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = dao.login(correo, clave);

        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", usuario);

            // Redirección por roles basada en id_per
            switch (usuario.getIdPer()) {
                case 1: // Administrador
                    response.sendRedirect("pages/dashboard.jsp");
                    break;
                case 2: // Empleado
                    response.sendRedirect("pages/editar_productos.jsp");
                    break;
                case 3: // Cliente
                    response.sendRedirect("index.jsp"); // Catálogo de compras
                    break;
                default:
                    response.sendRedirect("pages/login.jsp?error=RolNoValido");
            }
        } else {
            response.sendRedirect("pages/login.jsp?error=CredencialesIncorrectas");
        }
    }
}
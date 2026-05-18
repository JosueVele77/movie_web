package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.UsuarioDAO;
import io.github.josuevele77.movie_web.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Usuario u = new Usuario();
            u.setNombreUs(request.getParameter("nombre"));
            u.setCedulaUs(request.getParameter("cedula"));
            u.setCorreoUs(request.getParameter("correo"));
            u.setClaveUs(request.getParameter("clave"));
            u.setIdEst(Integer.parseInt(request.getParameter("id_est"))); // Captura el combo box

            UsuarioDAO dao = new UsuarioDAO();
            if (dao.registrar(u)) {
                // Redirecciona al login con un mensaje de éxito
                response.sendRedirect("pages/login.jsp?success=1");
            } else {
                response.sendRedirect("pages/registro.jsp?error=1");
            }
        } catch (Exception e) {
            response.sendRedirect("pages/registro.jsp?error=1");
        }
    }
}
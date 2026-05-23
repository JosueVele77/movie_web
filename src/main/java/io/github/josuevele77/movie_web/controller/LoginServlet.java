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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");

        // Controlamos que los parámetros no lleguen nulos desde la interfaz web
        if (correo == null || clave == null || correo.trim().isEmpty() || clave.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=1");
            return;
        }

        correo = correo.trim();
        clave = clave.trim();

        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = null;

        try {
            // Realiza la consulta a la base de datos
            usuario = dao.login(correo, clave);
        } catch (Exception e) {
            e.printStackTrace(); // Muestra en consola si hay un error de conexión SQL
        }

        // Si las credenciales son correctas y el objeto NO es nulo
        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", usuario);

            String contextPath = request.getContextPath();

            switch (usuario.getIdPer()) {
                case 1:
                    response.sendRedirect(contextPath + "/dashboard");
                    break;
                case 2:
                    response.sendRedirect(contextPath + "/pages/vendedor.jsp");
                    break;
                case 3:
                    response.sendRedirect(contextPath + "/index.jsp");
                    break;
                default:
                    response.sendRedirect(contextPath + "/pages/login.jsp?error=RolInvalido");
            }
        } else {
            // Si el usuario es nulo (correo o contraseña incorrectos), redirigimos al login con un error
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=credenciales");
        }
    }
}
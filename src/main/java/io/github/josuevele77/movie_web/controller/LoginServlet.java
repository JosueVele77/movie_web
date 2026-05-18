package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.UsuarioDAO;
import io.github.josuevele77.movie_web.model.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");

        // Controlamos que los parámetros no lleguen nulos desde la interfaz web
        if (correo == null || clave == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=1");
            return;
        }

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

            // Redirección robusta utilizando la raíz del contexto de la aplicación web
            String contextPath = request.getContextPath();

            switch (usuario.getIdPer()) {
                case 1: // Administrador
                    response.sendRedirect(contextPath + "/pages/dashboard.jsp");
                    break;
                case 2: // Empleado / Vendedor
                    response.sendRedirect(contextPath + "/pages/editar_productos.jsp");
                    break;
                case 3: // Cliente
                    response.sendRedirect(contextPath + "/index.jsp");
                    break;
                default:
                    response.sendRedirect(contextPath + "/pages/login.jsp?error=RolInvalido");
            }
        } else {
            // Si las credenciales fallan o el usuario no existe en la BD
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=1");
        }
    }
}
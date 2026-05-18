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

            String contextPath = request.getContextPath();

            switch (usuario.getIdPer()) {
                case 1:
                    response.sendRedirect(contextPath + "/dashboard");
                    break;
                case 2:
                    response.sendRedirect(contextPath + "/pages/editar_productos.jsp");
                    break;
                case 3:
                    response.sendRedirect(contextPath + "/index.jsp");
                    break;
                default:
                    response.sendRedirect(contextPath + "/pages/login.jsp?error=RolInvalido");
            }
        } else {
            // ¡PRUEBA DE DIAGNÓSTICO!: Si llega aquí, imprimimos un mensaje directo en el navegador
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h1>El usuario retornó NULL desde la base de datos.</h1>");
            response.getWriter().println("<p>Revisa las credenciales en tu formulario o la conexión en tu BD.</p>");
        }
    }
}
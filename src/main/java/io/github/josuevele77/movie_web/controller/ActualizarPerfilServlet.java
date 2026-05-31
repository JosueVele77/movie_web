package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.UsuarioDAO;
import io.github.josuevele77.movie_web.model.Usuario;
import io.github.josuevele77.movie_web.utils.CedulaValidator;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ActualizarPerfilServlet", value = "/ActualizarPerfilServlet")
public class ActualizarPerfilServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuarioActual = (Usuario) session.getAttribute("usuarioLogueado");

        if (usuarioActual == null) {
            response.sendRedirect("pages/login.jsp");
            return;
        }

        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");
        String cedula = request.getParameter("cedula");
        String avatarUrl = request.getParameter("avatarUrl");

        // Validación Blindada en Servidor
        if (!CedulaValidator.esValida(cedula)) {
            response.sendRedirect(request.getContextPath() + "/pages/profile.jsp?error=cedula_invalida");
            return;
        }

        // Mapeamos los datos modificados manteniendo el ID original
        usuarioActual.setNombreUs(nombre);
        usuarioActual.setCorreoUs(correo);
        usuarioActual.setClaveUs(clave);
        usuarioActual.setCedulaUs(cedula);
        if (avatarUrl != null && !avatarUrl.trim().isEmpty()) {
            usuarioActual.setAvatarUrl(avatarUrl.trim());
        }

        UsuarioDAO dao = new UsuarioDAO();
        boolean actualizado = dao.actualizarPerfil(usuarioActual);

        if (actualizado) {
            // Refrescar objeto de sesión para que el Navbar cambie de inmediato
            session.setAttribute("usuarioLogueado", usuarioActual);
            response.sendRedirect(request.getContextPath() + "/pages/profile.jsp?success=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/profile.jsp?error=true");
        }
    }
}

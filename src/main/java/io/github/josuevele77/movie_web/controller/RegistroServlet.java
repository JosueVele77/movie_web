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

@WebServlet(name = "RegistroServlet", value = "/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    private static final String DEFAULT_AVATAR_URL =
            "https://images.avataranimals.com/animals/transparent/albatross.webp?v=a60026c088dc0dee";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");
        String cedula = request.getParameter("cedula");
        String avatarUrl = request.getParameter("avatarUrl");
        String idEstParam = request.getParameter("id_est");

        if (!CedulaValidator.esValida(cedula)) {
            response.sendRedirect(request.getContextPath() + "/pages/registro.jsp?error=cedula_invalida");
            return;
        }

        int idEst = 1;
        try {
            if (idEstParam != null && !idEstParam.trim().isEmpty()) {
                idEst = Integer.parseInt(idEstParam.trim());
            }
        } catch (NumberFormatException ignored) {
            idEst = 1;
        }

        if (avatarUrl == null || avatarUrl.trim().isEmpty()) {
            avatarUrl = DEFAULT_AVATAR_URL;
        }

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombreUs(nombre);
        nuevoUsuario.setCorreoUs(correo);
        nuevoUsuario.setClaveUs(clave);
        nuevoUsuario.setCedulaUs(cedula);
        nuevoUsuario.setIdEst(idEst);
        nuevoUsuario.setAvatarUrl(avatarUrl.trim());
        nuevoUsuario.setIdPer(3);

        UsuarioDAO dao = new UsuarioDAO();
        boolean registrado = dao.registrar(nuevoUsuario);

        if (registrado) {
            Usuario usuarioRegistrado = dao.login(correo.trim(), clave.trim());
            request.getSession().setAttribute("usuarioLogueado", usuarioRegistrado != null ? usuarioRegistrado : nuevoUsuario);
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/registro.jsp?error=true");
        }
    }
}

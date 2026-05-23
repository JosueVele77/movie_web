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
import java.io.PrintWriter;

@WebServlet(name = "CambiarRolServlet", urlPatterns = {"/cambiarRol"})
public class CambiarRolServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession(false);
            String jsonResponse;

            // Validar sesión
            if (session == null) {
                jsonResponse = "{\"success\": false, \"message\": \"Sesión expirada\"}";
                out.print(jsonResponse);
                return;
            }

            // Obtener usuario logueado (debe ser admin)
            Usuario adminLogueado = (Usuario) session.getAttribute("usuarioLogueado");
            if (adminLogueado == null || adminLogueado.getIdPer() != 1) {
                jsonResponse = "{\"success\": false, \"message\": \"No tienes permisos para realizar esta acción\"}";
                out.print(jsonResponse);
                return;
            }

            // Obtener parámetros
            String usuarioIdStr = request.getParameter("usuarioId");
            String nuevoRolStr = request.getParameter("nuevoRol");
            String password = request.getParameter("password");

            // Validar parámetros
            if (usuarioIdStr == null || nuevoRolStr == null || password == null) {
                jsonResponse = "{\"success\": false, \"message\": \"Parámetros incompletos\"}";
                out.print(jsonResponse);
                return;
            }

            int usuarioId = Integer.parseInt(usuarioIdStr);
            int nuevoRol = Integer.parseInt(nuevoRolStr);

            // Verificar contraseña del administrador
            if (!verificarContraseña(adminLogueado.getCorreoUs(), password)) {
                jsonResponse = "{\"success\": false, \"message\": \"Contraseña incorrecta\"}";
                out.print(jsonResponse);
                return;
            }

            // Cambiar rol del usuario
            UsuarioDAO uDao = new UsuarioDAO();
            boolean actualizado = uDao.actualizarRol(usuarioId, nuevoRol);

            if (actualizado) {
                jsonResponse = "{\"success\": true, \"message\": \"Rol actualizado exitosamente\"}";
            } else {
                jsonResponse = "{\"success\": false, \"message\": \"Error al actualizar el rol\"}";
            }

            out.print(jsonResponse);

        } catch (NumberFormatException e) {
            String jsonResponse = "{\"success\": false, \"message\": \"Formato de datos inválido\"}";
            out.print(jsonResponse);
        } catch (Exception e) {
            e.printStackTrace();
            String jsonResponse = "{\"success\": false, \"message\": \"Error en el servidor\"}";
            out.print(jsonResponse);
        }
    }

    /**
     * Verifica si la contraseña proporcionada es correcta para el usuario
     * En una aplicación real, esto verificaría contra la BD con hashing de contraseñas
     */
    private boolean verificarContraseña(String correo, String passwordIngresada) {
        try {
            UsuarioDAO uDao = new UsuarioDAO();
            Usuario usuario = uDao.buscarPorCorreo(correo);

            if (usuario != null && usuario.getClaveUs() != null) {
                // Comparación simple - En producción usar bcrypt o similar
                return usuario.getClaveUs().equals(passwordIngresada);
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}


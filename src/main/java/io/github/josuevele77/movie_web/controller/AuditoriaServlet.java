package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AuditoriaServlet", urlPatterns = {"/auditoria"})
public class AuditoriaServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
            if (user != null && user.getIdPer() == 1) { // 1 for Admin
                List<Map<String, Object>> registroAuditoria = obtenerRegistroAuditoria();

                request.setAttribute("registroAuditoria", registroAuditoria);

                request.getRequestDispatcher("/pages/auditoria.jsp").forward(request, response);
            } else {
                response.sendRedirect("pages/login.jsp?error=unauthorized");
            }
        } else {
            response.sendRedirect("pages/login.jsp");
        }
    }

    private List<Map<String, Object>> obtenerRegistroAuditoria() {
        List<Map<String, Object>> registros = new ArrayList<>();
        LocalDateTime ahora = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

        // Datos de ejemplo - En una aplicación real, estos vendrían de una base de datos
        String[] acciones = {"LOGIN", "UPDATE", "CREATE", "DELETE", "LOGOUT"};
        String[] entidades = {"Película", "Usuario", "Producto", "Perfil", "Configuración"};
        String[] descripciones = {
            "Acceso al sistema",
            "Se actualizó el inventario",
            "Se creó nuevo producto",
            "Se eliminó película",
            "Cambio en perfil de usuario"
        };

        for (int i = 0; i < 10; i++) {
            Map<String, Object> registro = new HashMap<>();
            LocalDateTime fecha = ahora.minusHours(i);
            registro.put("fecha", fecha.format(formatter));
            registro.put("administrador", "admin@cinestore.com");
            registro.put("accion", acciones[i % acciones.length]);
            registro.put("entidad", entidades[i % entidades.length]);
            registro.put("descripcion", descripciones[i % descripciones.length]);

            registros.add(registro);
        }

        return registros;
    }
}


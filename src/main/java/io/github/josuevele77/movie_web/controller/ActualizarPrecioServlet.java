package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.ProductoDAO;
import io.github.josuevele77.movie_web.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ActualizarPrecioServlet", urlPatterns = {"/actualizarPrecio"})
public class ActualizarPrecioServlet extends HttpServlet {

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

            // Obtener usuario logueado (debe ser vendedor)
            Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
            if (user == null || user.getIdPer() != 2) { // 2 for Vendedor
                jsonResponse = "{\"success\": false, \"message\": \"No tienes permisos para realizar esta acción\"}";
                out.print(jsonResponse);
                return;
            }

            // Obtener parámetros
            String productoIdStr = request.getParameter("productoId");
            String nuevoPrecioStr = request.getParameter("nuevoPrecio");
            String descuentoStr = request.getParameter("descuento");

            // Validar parámetros
            if (productoIdStr == null || nuevoPrecioStr == null) {
                jsonResponse = "{\"success\": false, \"message\": \"Parámetros incompletos\"}";
                out.print(jsonResponse);
                return;
            }

            int productoId = Integer.parseInt(productoIdStr);
            double nuevoPrecio = Double.parseDouble(nuevoPrecioStr);
            double descuento = descuentoStr != null ? Double.parseDouble(descuentoStr) : 0;

            // Validar que el precio sea positivo
            if (nuevoPrecio <= 0) {
                jsonResponse = "{\"success\": false, \"message\": \"El precio debe ser mayor a 0\"}";
                out.print(jsonResponse);
                return;
            }

            // Actualizar precio
            ProductoDAO pDao = new ProductoDAO();
            boolean actualizado = pDao.actualizarPrecio(productoId, nuevoPrecio, descuento);

            if (actualizado) {
                jsonResponse = "{\"success\": true, \"message\": \"Precio actualizado exitosamente\"}";
            } else {
                jsonResponse = "{\"success\": false, \"message\": \"Error al actualizar el precio\"}";
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
}


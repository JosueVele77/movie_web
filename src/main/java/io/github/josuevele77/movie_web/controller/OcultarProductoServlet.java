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

@WebServlet(name = "OcultarProductoServlet", urlPatterns = {"/ocultarProducto"})
public class OcultarProductoServlet extends HttpServlet {

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

            // Obtener parámetro
            String productoIdStr = request.getParameter("productoId");

            // Validar parámetro
            if (productoIdStr == null) {
                jsonResponse = "{\"success\": false, \"message\": \"Parámetro incompleto\"}";
                out.print(jsonResponse);
                return;
            }

            int productoId = Integer.parseInt(productoIdStr);

            // Ocultar producto
            ProductoDAO pDao = new ProductoDAO();
            boolean ocultado = pDao.ocultarProducto(productoId);

            if (ocultado) {
                jsonResponse = "{\"success\": true, \"message\": \"Producto ocultado exitosamente\"}";
            } else {
                jsonResponse = "{\"success\": false, \"message\": \"Error al ocultar el producto\"}";
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


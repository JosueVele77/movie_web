package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.CompraDAO;
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

@WebServlet(name = "CompraServlet", urlPatterns = {"/procesarCompra"})
public class CompraServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Obtener la sesión y verificar usuario
            HttpSession session = request.getSession(false);
            if (session == null) {
                out.println("{\"success\": false, \"message\": \"Sesión expirada. Por favor, inicia sesión de nuevo.\"}");
                out.close();
                return;
            }

            Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
            if (usuario == null) {
                out.println("{\"success\": false, \"message\": \"Usuario no autenticado.\"}");
                out.close();
                return;
            }

            // Obtener parámetros de la compra
            String productoId = request.getParameter("productoId");
            String titularTarjeta = request.getParameter("titularTarjeta");
            String numeroTarjeta = request.getParameter("numeroTarjeta");
            String totalStr = request.getParameter("total");
            String productoNombre = request.getParameter("productoNombre");

            // Validar parámetros
            if (productoId == null || titularTarjeta == null || numeroTarjeta == null || totalStr == null) {
                out.println("{\"success\": false, \"message\": \"Parámetros incompletos.\"}");
                out.close();
                return;
            }

            int idProducto = Integer.parseInt(productoId);
            double total = Double.parseDouble(totalStr);

            CompraDAO compraDAO = new CompraDAO();
            if (compraDAO.usuarioPoseeProducto(usuario.getIdUs(), idProducto)) {
                out.println("{\"success\": false, \"message\": \"Ya eres dueño de esta película.\"}");
                out.close();
                return;
            }

            ProductoDAO productoDAO = new ProductoDAO();
            if (!productoDAO.existeProducto(idProducto)) {
                boolean registrado = productoDAO.registrarProductoBasico(idProducto, productoNombre, total);
                if (!registrado) {
                    out.println("{\"success\": false, \"message\": \"No se pudo registrar la película.\"}");
                    out.close();
                    return;
                }
            }

            // Validar tarjeta (Luhn algorithm simplificado)
            if (!validarTarjeta(numeroTarjeta)) {
                out.println("{\"success\": false, \"message\": \"Número de tarjeta inválido.\"}");
                out.close();
                return;
            }

            // Registrar compra en la base de datos
            int idCompra = compraDAO.registrarCompra(usuario.getIdUs(), total, titularTarjeta, numeroTarjeta);

            if (idCompra > 0) {
                // Registrar detalle de la compra
                compraDAO.registrarDetalleCompra(idCompra, idProducto, 1, total);

                out.println("{\"success\": true, \"message\": \"¡Compra realizada exitosamente!\", \"idCompra\": " + idCompra + "}");
            } else {
                out.println("{\"success\": false, \"message\": \"Error al procesar la compra. Intenta de nuevo.\"}");
            }
        } catch (NumberFormatException e) {
            out.println("{\"success\": false, \"message\": \"Datos inválidos.\"}");
            e.printStackTrace();
        } catch (Exception e) {
            out.println("{\"success\": false, \"message\": \"Error del servidor: " + e.getMessage() + "\"}");
            e.printStackTrace();
        } finally {
            out.close();
        }
    }

    /**
     * Valida el número de tarjeta usando el algoritmo de Luhn
     */
    private boolean validarTarjeta(String numeroTarjeta) {
        if (numeroTarjeta == null || numeroTarjeta.length() < 13 || numeroTarjeta.length() > 19) {
            return false;
        }

        // Verificar que solo contenga números
        if (!numeroTarjeta.matches("\\d+")) {
            return false;
        }

        // Algoritmo de Luhn
        int suma = 0;
        boolean multiplicar = false;

        for (int i = numeroTarjeta.length() - 1; i >= 0; i--) {
            int digito = Character.getNumericValue(numeroTarjeta.charAt(i));

            if (multiplicar) {
                digito *= 2;
                if (digito > 9) {
                    digito -= 9;
                }
            }

            suma += digito;
            multiplicar = !multiplicar;
        }

        return suma % 10 == 0;
    }
}

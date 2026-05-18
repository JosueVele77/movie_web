package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.ProductoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ReactivarProductoServlet")
public class ReactivarProductoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id_pr");

        if (idParam != null) {
            try {
                int idPr = Integer.parseInt(idParam);
                ProductoDAO dao = new ProductoDAO();

                // Ejecuta la actualización SQL (estado_pr = TRUE)
                if (dao.reactivarProducto(idPr)) {
                    // Recarga la Dashboard notificando el éxito
                    response.sendRedirect(request.getContextPath() + "/dashboard?reactivado=1");
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
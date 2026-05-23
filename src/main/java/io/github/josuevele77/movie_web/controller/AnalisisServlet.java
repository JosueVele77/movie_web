package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.CompraDAO;
import io.github.josuevele77.movie_web.model.HistorialCompra;
import io.github.josuevele77.movie_web.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AnalisisServlet", urlPatterns = {"/analisis"})
public class AnalisisServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
            if (user != null && user.getIdPer() == 1) { // 1 for Admin
                CompraDAO cDao = new CompraDAO();

                List<HistorialCompra> historialCompras = cDao.obtenerHistorial();
                Map<String, Double> ventasPorDia = calcularVentasPorDia(historialCompras);
                double totalVentas = calcularTotalVentas(historialCompras);
                int totalTransacciones = historialCompras.size();

                request.setAttribute("ventasPorDia", ventasPorDia);
                request.setAttribute("totalVentas", totalVentas);
                request.setAttribute("totalTransacciones", totalTransacciones);

                request.getRequestDispatcher("/pages/analisis.jsp").forward(request, response);
            } else {
                response.sendRedirect("pages/login.jsp?error=unauthorized");
            }
        } else {
            response.sendRedirect("pages/login.jsp");
        }
    }

    private Map<String, Double> calcularVentasPorDia(List<HistorialCompra> historialCompras) {
        Map<String, Double> ventasPorDia = new LinkedHashMap<>();
        LocalDate hoy = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // Inicializar últimos 7 días
        for (int i = 6; i >= 0; i--) {
            LocalDate fecha = hoy.minusDays(i);
            ventasPorDia.put(fecha.format(formatter), 0.0);
        }

        // Agregar ventas al mapa
        if (historialCompras != null) {
            for (HistorialCompra compra : historialCompras) {
                // Por ahora, distribuir las ventas aleatoriamente entre los días
                // En una aplicación real, esto vendría de la base de datos
                String diaAleatorio = (String) ventasPorDia.keySet().toArray()[(int)(Math.random() * 7)];
                ventasPorDia.put(diaAleatorio, ventasPorDia.get(diaAleatorio) + compra.getTotal());
            }
        }

        return ventasPorDia;
    }

    private double calcularTotalVentas(List<HistorialCompra> historialCompras) {
        double total = 0.0;
        if (historialCompras != null) {
            for (HistorialCompra compra : historialCompras) {
                total += compra.getTotal();
            }
        }
        return total;
    }
}


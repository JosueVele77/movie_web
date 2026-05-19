package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.ProductoDAO;
import io.github.josuevele77.movie_web.dao.UsuarioDAO;
import io.github.josuevele77.movie_web.model.Producto;
import io.github.josuevele77.movie_web.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
            if (user != null && user.getIdPer() == 1) { // 1 for Admin
                ProductoDAO pDao = new ProductoDAO();
                UsuarioDAO uDao = new UsuarioDAO();

                int totalProducts = pDao.contarTotalProductos();
                int hiddenProducts = pDao.contarProductosOcultos();
                int totalClients = uDao.contarClientes();
                List<Producto> hiddenProductList = pDao.listarOcultos();

                request.setAttribute("totalP", totalProducts);
                request.setAttribute("ocultosP", hiddenProducts);
                request.setAttribute("totalC", totalClients);
                request.setAttribute("listaOcultos", hiddenProductList);

                request.getRequestDispatcher("/pages/dashboard.jsp").forward(request, response);
            } else {
                response.sendRedirect("pages/login.jsp?error=unauthorized");
            }
        } else {
            response.sendRedirect("pages/login.jsp");
        }
    }
}
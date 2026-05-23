package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.ProductoDAO;
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

@WebServlet(name = "VendedorServlet", urlPatterns = {"/vendedor"})
public class VendedorServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
            if (user != null && user.getIdPer() == 2) { // 2 for Vendedor
                ProductoDAO pDao = new ProductoDAO();

                int totalProducts = pDao.contarTotalProductos();
                List<Producto> todosProductos = pDao.listarTodos();

                request.setAttribute("totalP", totalProducts);
                request.setAttribute("todosProductos", todosProductos);

                request.getRequestDispatcher("/pages/vendedor.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=unauthorized");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        }
    }
}


package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.FavoritoDAO;
import io.github.josuevele77.movie_web.model.Favorito;
import io.github.josuevele77.movie_web.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "FavoritoServlet", urlPatterns = {"/favoritos"})
public class FavoritoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        Usuario usuario = session != null ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (usuario == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.println("{\"success\":false,\"requiresAuth\":true,\"favorites\":[]}");
            out.close();
            return;
        }

        FavoritoDAO favoritoDAO = new FavoritoDAO();
        List<Favorito> favoritos = favoritoDAO.listarPorUsuario(usuario.getIdUs());

        StringBuilder json = new StringBuilder();
        json.append("{\"success\":true,\"favorites\":[");
        for (int i = 0; i < favoritos.size(); i++) {
            Favorito fav = favoritos.get(i);
            json.append("{\"id\":").append(fav.getTmdbId())
                .append(",\"title\":\"").append(escapeJson(fav.getTitle())).append("\"")
                .append(",\"posterPath\":\"").append(escapeJson(fav.getPosterPath())).append("\"")
                .append(",\"date\":\"").append(escapeJson(fav.getReleaseYear())).append("\"}");
            if (i < favoritos.size() - 1) {
                json.append(",");
            }
        }
        json.append("]}");
        out.println(json);
        out.close();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        Usuario usuario = session != null ? (Usuario) session.getAttribute("usuarioLogueado") : null;
        if (usuario == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.println("{\"success\":false,\"requiresAuth\":true}");
            out.close();
            return;
        }

        String tmdbIdStr = request.getParameter("tmdbId");
        String title = request.getParameter("title");
        String posterPath = request.getParameter("posterPath");
        String releaseYear = request.getParameter("releaseYear");

        if (tmdbIdStr == null || tmdbIdStr.isEmpty()) {
            out.println("{\"success\":false,\"message\":\"Datos incompletos.\"}");
            out.close();
            return;
        }

        int tmdbId;
        try {
            tmdbId = Integer.parseInt(tmdbIdStr);
        } catch (NumberFormatException e) {
            out.println("{\"success\":false,\"message\":\"ID inválido.\"}");
            out.close();
            return;
        }

        FavoritoDAO favoritoDAO = new FavoritoDAO();
        boolean existe = favoritoDAO.existeFavorito(usuario.getIdUs(), tmdbId);
        boolean ok;
        boolean nowFavorite;

        if (existe) {
            ok = favoritoDAO.eliminarFavorito(usuario.getIdUs(), tmdbId);
            nowFavorite = false;
        } else {
            ok = favoritoDAO.agregarFavorito(usuario.getIdUs(), tmdbId,
                    title == null ? "" : title,
                    posterPath == null ? "" : posterPath,
                    releaseYear == null ? "" : releaseYear);
            nowFavorite = true;
        }

        if (ok) {
            out.println("{\"success\":true,\"isFavorite\":" + nowFavorite + "}");
        } else {
            out.println("{\"success\":false,\"message\":\"No se pudo actualizar el favorito.\"}");
        }
        out.close();
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}


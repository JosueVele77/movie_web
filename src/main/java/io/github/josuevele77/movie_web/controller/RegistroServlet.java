package io.github.josuevele77.movie_web.controller;

import io.github.josuevele77.movie_web.dao.UsuarioDAO;
import io.github.josuevele77.movie_web.model.Usuario;
import io.github.josuevele77.movie_web.utils.CedulaValidator; // <-- Importación del validador
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroServlet", value = "/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Recibir los parámetros del formulario de registro.jsp
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");
        String cedula = request.getParameter("cedula"); // <-- Obtenemos la cédula
        String avatarUrl = request.getParameter("avatarUrl");

        // 2. VALIDACIÓN EN EL BACKEND
        // Verificamos matemáticamente que la cédula sea correcta usando la clase Utils
        if (!CedulaValidator.esValida(cedula)) {
            // Si intentan enviar datos falsos evadiendo el JavaScript, los rebotamos
            response.sendRedirect(request.getContextPath() + "/pages/registro.jsp?error=cedula_invalida");
            return; // <-- Return IMPORTANTÍSIMO para que no se siga ejecutando el código hacia abajo
        }

        // 3. Crear el objeto Usuario y setear los valores validados
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombreUs(nombre);
        nuevoUsuario.setCorreoUs(correo);
        nuevoUsuario.setClaveUs(clave);
        nuevoUsuario.setCedulaUs(cedula); // <-- Guardamos la cédula real y ya validada
        nuevoUsuario.setIdEst(1);         // Asumiendo que '1' es un ID válido en tu tabla tb_estado_civil
        nuevoUsuario.setAvatarUrl(avatarUrl);
        nuevoUsuario.setIdPer(3);

        // 4. Llamar al DAO para guardar en la base de datos
        UsuarioDAO dao = new UsuarioDAO();
        boolean registrado = dao.registrar(nuevoUsuario);

        // 5. Validar la inserción en BD y redirigir
        if (registrado) {
            // Si el registro es exitoso, redirigimos a la página de inicio
            request.getSession().setAttribute("usuarioLogueado", nuevoUsuario);
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            // Si falla en la BD (por ejemplo, el correo o cédula ya existen y son UNIQUE), mostramos error
            response.sendRedirect(request.getContextPath() + "/pages/registro.jsp?error=true");
        }
    }
}
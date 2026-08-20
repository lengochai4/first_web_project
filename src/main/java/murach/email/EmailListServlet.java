package murach.email;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import murach.business.User;
import murach.data.UserDB;

@WebServlet("/emailList")
public class EmailListServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Hỗ trợ tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String url = "/index.html";

        // Lấy action gửi lên từ form
        String action = request.getParameter("action");
        if (action == null) {
            action = "join";
        }

        if (action.equals("join")) {
            url = "/index.html";
        }
        else if (action.equals("add")) {
            // Lấy đúng tên các tham số khớp với thuộc tính 'name' trong form HTML
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");

            User user = new User(firstName, lastName, email);
            UserDB.insert(user);

            // Đưa đối tượng user vào request để truyền sang JSP
            request.setAttribute("user", user);
            url = "/thanks.jsp";
        }

        // Chuyển tiếp tới trang đích
        getServletContext()
                .getRequestDispatcher(url)
                .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
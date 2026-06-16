# TODO - Spring Boot 3 migration (JSP preserved)

- [ ] Create new Spring Boot 3 project structure (single module) with embedded Tomcat
- [ ] Add `pom.xml` (Java 17, JSP support, servlet container)
- [ ] Add `application.properties` (JSP prefix/suffix + DB config)
- [ ] Move/serve existing JSPs via Spring view resolver (preserve files/URLs; no UI changes)
- [ ] Add Service layer wrapping existing DAOs: AuthService, ExpenseService, ProfileService
- [ ] Add Controllers mapping all existing URLs:
  - /index.jsp GET/POST
  - /register.jsp GET/POST
  - /forget.jsp GET/POST
  - /dashboard.jsp GET (and POST only if needed for delete)
  - /expenses.jsp GET/POST
  - /expensechart.jsp GET/POST
  - /codeanalysis.jsp GET
  - /profile.jsp GET
  - /logout.jsp GET
  - /delete_account.jsp GET/POST
  - /updateProfileServlet POST
- [ ] Implement missing endpoint: POST /updateProfileServlet (update user + redirect with success=true)
- [ ] Add configuration classes for JSP rendering + component scanning
- [ ] Add Dockerfile
- [ ] Add docker-compose.yml
- [ ] Add Render deployment configuration
- [ ] Add Railway deployment configuration
- [ ] Verify build/run: `mvn spring-boot:run` and `java -jar app.jar`
- [ ] Move JSPs under src/main/webapp/WEB-INF/jsp/ and ensure view names match
- [ ] Ensure Controllers/services compile (resolve IDEA errors by running mvn test/build)
- [ ] Generate app.jar naming + update Docker/Render/Railway configs if needed



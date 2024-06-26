# phoenix_server
exemplo de aplicação elixir phoenix


## Appphoenix

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


```
http://junior-ms-7c09.lvh.me/

openssl req -newkey rsa:2048 -nodes -keyout /opt/cert/junior-ms-7c09.lvh.me.key  -out /opt/cert/junior-ms-7c09.lvh.me.crt
cat /opt/cert/junior-ms-7c09.lvh.me.crt > /opt/cert/junior-ms-7c09.lvh.me.csr

/opt/cert/junior-ms-7c09.lvh.me.crt
/opt/cert/junior-ms-7c09.lvh.me.key  

#ssl_certificate /opt/cert/junior-ms-7c09.lvh.me.crt;
#ssl_certificate_key /opt/cert/junior-ms-7c09.lvh.me.key;

ssl_certificate junior-ms-7c09.lvh.me.crt ;
ssl_certificate_key junior-ms-7c09.lvh.me.key ;

openssl req -newkey rsa:2048 -nodes -keyout  junior-ms-7c09.lvh.me.key  -out  junior-ms-7c09.lvh.me.crt
cat  junior-ms-7c09.lvh.me.crt >  junior-ms-7c09.lvh.me.csr
```
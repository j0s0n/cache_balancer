#Varnish Load balancer doesn't work with IP and Port redirection.
#Use only with DNS names to point to the different containers.

vcl 4.1;

import directors;

backend web1 {
    .host = "172.17.0.3";
#    .host = "192.168.56.101";
#    .port = "5001";
}

backend web2 {
    .host = "172.17.0.4";
#    .host = "192.168.56.101";
#    .port = "5002";
}

backend web3 {
    .host = "172.17.0.5";
#    .host = "192.168.56.101";
#    .port = "5003";
}

sub vcl_init {
    new load_balancer = directors.round_robin();
    load_balancer.add_backend(web1);
    load_balancer.add_backend(web2);
    load_balancer.add_backend(web3);
}

sub vcl_recv {
    set req.backend_hint = load_balancer.backend();
}

sub vcl_backend_response {
}

sub vcl_deliver {
}
wireguard:
  interfaces:
    wg0:
      # The two following keys are non-wireguard options.
      # Delete the config file. The interface will also be stopped and disables.
      # Defaults to False.
      #delete: False
      # Start and enable the service. Setting this to false causes the interface
      # to be stopped and disabled. Defaults to True.
      #enable: True

      config:
        # see wg(8) and wg-quick(8) for supported keys. We use all lowercase
        # letters.
        Address:
          - 10.251.1.1/24

        PrivateKey: GMzbKWx3bp/Mxz1Dl2dR2NVeTNDxAdqeNv6i8lgCyk8=

        ListenPort: 51820
        PostUp: iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
        PostDown: iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eno1 -j MASQUERADE

      peers:
        - PublicKey: WenT2hF6W6PQMTbMFNBq0gXWCboaR3tVYZHQoZ19jWE=
          # AllowedIPs must be a list of strings or a comma separated string
          Endpoint: 158.130.176.233:51820
          AllowedIPs:
            - 10.251.1.101/32

        - PublicKey: sSCzoADeo0efp6olOX5pQ20pXoMjdcHsqGBZ98+MyAw=
          # AllowedIPs must be a list of strings or a comma separated string
          Endpoint: 10.102.163.239:51820
          AllowedIPs:
            - 10.251.1.102/32

        - PublicKey: LPdJaiDhI9GBbt2bhaMz/rQ8XUt0wL1VAzR/uuy4Wnk=
          # AllowedIPs must be a list of strings or a comma separated string
          Endpoint: 35.207.8.196:51820
          AllowedIPs:
            - 10.251.1.103/32


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

        PrivateKey: oDn999ZyCUZ6PgNqm74qt4MPTgZGPEGZ9wyWtjuCoFs=

        # address must be a list of strings or a comma separated string
        Address:
          - 10.251.1.103/24
        ListenPort: 51820

      peers:
        - PublicKey: C6Y7b9wZOCcnARJaLBd/70x9RVDNZwSQIU6fSMt0Fi4=
          # AllowedIPs must be a list of strings or a comma separated string
          Endpoint: 158.130.236.92:51820
          AllowedIPs:
            - 10.251.1.0/24
            - 10.150.40.0/24
            - 10.150.12.0/23

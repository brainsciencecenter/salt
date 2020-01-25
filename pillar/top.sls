base:
  '*':
    - defaults
    - packages
    - software
    - icinga-files

  'compute-*':
    - nodegroup.compute-nodes

  'bfb.cfn.upenn.edu':
    - hosts.bfb_cfn_upenn_edu

  'picsl-huron.pmacs.upenn.edu':
    - hosts.picsl-huron_pmacs_upenn_edu

  'clippy.cfn.upenn.edu':
    - hosts.clippy_cfn_upenn_edu

  'chead.uphs.upenn.edu':
    - software
    - hosts.chead_uphs_upenn_edu

  'compute-1-6.chead.uphs.upenn.edu':
    - hosts.compute-1-6_chead_uphs_upenn_edu

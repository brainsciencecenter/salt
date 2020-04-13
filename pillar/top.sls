base:
  '*':
    - defaults
    - packages
    - software
    - icinga-files

  '*.pennbrain.upenn.edu':
    - software/usergroups
    
  'compute*.chead.uphs.upenn.edu':
    - hosts.compute-0-0_chead_uphs_upenn_edu

  'bfb.cfn.upenn.edu':
    - hosts.bfb_cfn_upenn_edu

  'bsc-compute-image.pennbrain.upenn.edu':
    - hosts.bsc-compute-image-pennbrain-upenn-edu

  'holder3.pennbrain.upenn.edu':
    - hosts.holder3-pennbrain-upenn-edu

  'holder6.pennbrain.upenn.edu':
    - hosts.holder6-pennbrain-upenn-edu

  'picsl-huron.pmacs.upenn.edu':
    - hosts.picsl-huron_pmacs_upenn_edu

  'clippy.cfn.upenn.edu':
    - hosts.clippy_cfn_upenn_edu

  'chead.uphs.upenn.edu':
    - software
    - hosts.chead_uphs_upenn_edu

  'compute-1-6.chead.uphs.upenn.edu':
    - hosts.compute-1-6_chead_uphs_upenn_edu

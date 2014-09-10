ALL = {
#                          risk(0%-80%)   importance(1-5)  tests covering(0%-100%)
  features_config:         [20           ,5                ,0  ],
  incidents:               [10           ,2                ,100],
  criticalities:           [20           ,2                ,0  ],
  expressions_suggestions: [70           ,3                ,60 ],
  group_approvals:         [40           ,2                ,0  ],
  group_deletions:         [40           ,2                ,0  ],
  profiles:                [40           ,3                ,0  ],
  cycle_confirmations:     [50           ,5                ,50 ],
  objectives_approvals:    [40           ,2                ,0  ],
  cycles:                  [60           ,5                ,20 ],
  analysis_matrices:       [70           ,5                ,30 ],
  publishes:               [60           ,5                ,0  ],
  versions:                [60           ,5                ,0  ],
  tactics:                 [60           ,5                ,60 ],
  strategies:              [55           ,5                ,60 ],
  approvals:               [60           ,4                ,50 ],
  back_referer:            [80           ,4                ,0  ],
  authorization:           [80           ,2                ,0  ],
  priorities_approvals:    [20           ,4                ,0  ]
}

def priority(risk, importance, tests_cover)
  risk + importance*16 - tests_cover*0.8
end

puts ALL.sort_by{|key, attrs| priority(*attrs)}.reverse.map{|(key, attrs)| "#{key}: #{priority(*attrs)}"}

# Database columns description
##  approvals
*    __id__: Autoincrementing primary key. 
*    __user_id__: Foreign key that refers to the user that made the approval or rejection.
*    __expression_id__: Kind of foreign key that refers to a text expression or a time expression.
*    __expression_type__: Complement expression_id, representing the table associated. Possible values: "TextExpression", "TimeExpression".
*    __positive__: true when is an approval and false when is an rejection.
*    __role_id__: Kind of foreign key that refers to an role that is represented internally in the application, through the file "config/roles.txt".
*    __created_at__: When the tuple was created.
*    __updated_at__: The last time the tuple was updated.

##  companies
*    __id__: Autoincrementing primary key. 
*    __name__: Name of the company.
*    __created_at__: When the tuple was created.
*    __updated_at__: The last time the tuple was updated.

##  cycles
*    __id__: Autoincrementing primary key. 
*    __incident_id__: Foreign key that refers to the incident that the cycle belongs.
*    __number__: Number of the cycle.
*    __from__: When the cycle planning was started.
*    __to__: When the cycle planning will end.
*    __closed__: True if the cycle was closed.
*    __priorities__: Description of the cycle priorities.
*    __priorities_approval_status__: True if the priorities were approved.
*    __created_at__: When the tuple was created.
*    __updated_at__: The last time the tuple was updated.

##  features_configs
*    __id__: Autoincrementing primary key. 
*    __user_id__: Foreign key that refers to the user that made the configuration.
*    __thesis_tools__: True if the thesis tools are enabled.

##  groups
*    __id__: Autoincrementing primary key. 
*    __father_id__: Foreign key that refers to an group. Through this attribute is represented the hierarchy: Objective > Strategies > Tactics.
*    __cycle_id__: Foreign key that refers the cycle that the group belongs.
*    __name__: Name of the group. The possible values are: 'Objective', 'Strategy' or 'Tactic'.
*    __criticality__: Criticality of the group. The possible values are: 'L', 'M' or 'H', which represent Low, Medium and High.
*    __created_at__: When the tuple was created.
*    __updated_at__: The last time the tuple was updated.

#  incidents
*    __id__: Autoincrementing primary key. 
*    __company_id__: Foreign key that refers to the company that own the incident.
*    __name__: Name of the incident.
*    __created_at__: When the tuple was created.
*    __updated_at__: The last time the tuple was updated.

##  reuse_configurations
*    __id__: Autoincrementing primary key. 
*    __user_id__: Foreign key that refers to the user that made de configuration.
*    __hierarchy__: True if the reuse of strategy hierarchy is enabled.
*    __user_filter_type__: Type of user filtering that will be used in the list of expressions suggested to be reused. The possible values are "specific", "all".
    *    __specific__: Only show expressions that were created by an specific user.
    *    __all__: Ignore the user that created the expressions.
*    __user_filter_value__: Specify the user email that will be used when the user_filter_type is "specific". Otherwise is null.
*    __incident_filter_type__: Type of incident filtering that will be used. The possible values are "current", "specific", "all".
    *    __current__: Only show expressions that were created in the incident were the expressions will be created.
    *    __specific__: Only show expressions that were created in an specific incident.
    *    __all__: Ignore the incident that owns the expression.
*    __incident_filter_value__: Specify the incident that will be used when the user_filter_type is "specific". Otherwise is null.
*    __date_filter__: Max of months that the expression must have to be shown in the list of suggested expressions.
*    __enabled__: True if the reuse is enabled.

##  text_expressions
*    __id__: Autoincrementing primary key. 
*    __cycle_id__: Foreign key that refers to the cycle that the expression was created. That attribute is an redundance (since it's possible to know the cycle through the group) used to optimize some searches.
*    __group_id__: Foreign key that refers to the group that own the expression.
*    __owner_id__: Foreign key that refers to the user that created the expression.
*    __name__: name of the expression. The possible values are: 'Objective', 'How', 'Who', 'What', 'Where', 'Response Action'.
*    __text__: The text of the expression.
*    __source__: Source of the expression.
*    __reused__: True if the expression was reused.
*    __artificial__: True if the expression was generated automatically in strategy hierarchy reuse.
*    __created_at__: When the tuple was created.
*    __updated_at__: The last time the tuple was updated.

##  time_expressions
*    __id__: Autoincrementing primary key. 
*    __cycle_id__: Foreign key that refers to the cycle that the expression was created. That attribute is an redundance (since it's possible to know the cycle through the group) used to optimize some searches.
*    __group_id__: Foreign key that refers to the group that own the expression.
*    __owner_id__: Foreign key that refers to the user that created the expression.
*    __name__: name of the expression. The possible values are: 'When'
*    __text__: The text of the expression, when it content is a free-written text.
*    __when__: The date and time of the expression, when it content is an well formatted date and time.
*    __source__: Source of the expression.
*    __reused__: True if the expression was reused.
*    __artificial__: True if the expression was generated automatically in strategy hierarchy reuse.
*    __created_at__: When the tuple was created.
*    __updated_at__: The last time the tuple was updated.

##  user_roles
*    __id__: Autoincrementing primary key. 
*    __user_id__: Foreign key that refers to an user.
*    __role_id__: Kind of foreign key that refers to an role that is represented internally in the application, through the file "config/roles.txt".

##  users
*    __id__: Autoincrementing primary key. 
*    __company_id__: Foreign key that refers to the company that the user belongs.
*    __email__: Email of the user.
*    __name__: Name of the user.
*    __phone__: Phone of the user.
*    __encrypted_password__: Password of the user.
*    __created_at__: When the tuple was created.
*    __updated_at__: The last time the tuple was updated.

##  versions
*    __id__: Autoincrementing primary key. 
*    __cycle_id__: Foreign key that refers to the cycle that owns that version.
*    __user_id__: Foreign key that refers to the user that issued that version.
*    __number__: The number of the version.
*    __ics234_pdf__: Stores the PDF of ICS-234.
*    __ics202_pdf__: Stores the PDF of ICS-202.
*    __created_at__: When the tuple was created.
*    __updated_at__: The last time the tuple was updated.

##  url_tracks
*    __id__: Autoincrementing primary key.
*    __url__: The url accessed by the user.
*    __datetime__: When the user accessed the url.
*    __session_id__: Stores the session id to keep track of the user history. 
*    __get_referer__: True if the url requested return a valid page.
*    __from_config_referer__: True if the url requested return a configuration page.
*    __is_backable__: False until the user is visiting this url and doesn't change it.

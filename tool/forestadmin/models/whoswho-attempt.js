// This model was generated by Lumber. However, you remain in control of your models.
// Learn how here: https://docs.forestadmin.com/documentation/v/v5/reference-guide/models/enrich-your-models
module.exports = (sequelize, DataTypes) => {
  const { Sequelize } = sequelize;
  // This section contains the fields of your model, mapped to your table's columns.
  // Learn more here: https://docs.forestadmin.com/documentation/v/v5/reference-guide/models/enrich-your-models#declaring-a-new-field-in-a-model
  const WhoswhoAttempt = sequelize.define('whoswho_attempt', {
    createdAt: {
      type: DataTypes.DATE,
    },
    updatedAt: {
      type: DataTypes.DATE,
    },
    success: {
      type: DataTypes.INTEGER,
    },
  }, {
    tableName: 'whoswho_attempt',
    underscored: true,
  });

  // This section contains the relationships for this model. See: https://docs.forestadmin.com/documentation/v/v5/reference-guide/relationships#adding-relationships.
  WhoswhoAttempt.associate = (models) => {
    WhoswhoAttempt.belongsTo(models.user, {
      foreignKey: {
        name: 'authorIdKey',
        field: 'author_id',
      },
      as: 'author',
    });
    WhoswhoAttempt.belongsTo(models.team, {
      foreignKey: {
        name: 'targetTeamIdKey',
        field: 'target_team_id',
      },
      as: 'targetTeam',
    });
    WhoswhoAttempt.belongsTo(models.team, {
      foreignKey: {
        name: 'authorTeamIdKey',
        field: 'author_team_id',
      },
      as: 'authorTeam',
    });
    WhoswhoAttempt.belongsTo(models.user, {
      foreignKey: {
        name: 'targetUserIdKey',
        field: 'target_user_id',
      },
      as: 'targetUser',
    });
  };

  return WhoswhoAttempt;
};

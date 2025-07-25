import './StatsCard.css';

const StatsCard = ({ title, value, change, icon: Icon, color, loading }) => {
  const colorClasses = {
    blue: 'bg-blue-100 text-blue-600',
    green: 'bg-green-100 text-green-600',
    purple: 'bg-purple-100 text-purple-600',
    orange: 'bg-orange-100 text-orange-600',
    red: 'bg-red-100 text-red-600',
  };

  return (
    <div className="statscard-card">
      <div className="statscard-body">
        <div className="statscard-row">
          <div className="flex-1">
            <p className="statscard-title">{title}</p>
            {loading ? (
              <div className="mt-2">
                <div className="statscard-loader"></div>
              </div>
            ) : (
              <>
                <p className="statscard-value">{value}</p>
                <p className="statscard-change">{change}</p>
              </>
            )}
          </div>
          <div className={`statscard-icon statscard-${color || 'blue'}`}>
            <Icon className="w-6 h-6" />
          </div>
        </div>
      </div>
    </div>
  );
};

export default StatsCard;

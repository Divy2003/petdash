const StatsCard = ({ title, value, change, icon: Icon, color, loading }) => {
  const colorClasses = {
    blue: 'bg-blue-100 text-blue-600',
    green: 'bg-green-100 text-green-600',
    purple: 'bg-purple-100 text-purple-600',
    orange: 'bg-orange-100 text-orange-600',
    red: 'bg-red-100 text-red-600',
  };

  return (
    <div className="card">
      <div className="card-body">
        <div className="flex items-center justify-between">
          <div className="flex-1">
            <p className="text-sm font-medium text-gray-600">{title}</p>
            {loading ? (
              <div className="mt-2">
                <div className="h-8 bg-gray-200 rounded animate-pulse"></div>
              </div>
            ) : (
              <>
                <p className="text-2xl font-bold text-gray-900 mt-2">{value}</p>
                <p className="text-sm text-gray-500 mt-1">{change}</p>
              </>
            )}
          </div>
          <div className={`p-3 rounded-lg ${colorClasses[color] || colorClasses.blue}`}>
            <Icon className="w-6 h-6" />
          </div>
        </div>
      </div>
    </div>
  );
};

export default StatsCard;

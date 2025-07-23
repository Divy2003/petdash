import { FiUser, FiBookOpen, FiUserCheck, FiDollarSign } from 'react-icons/fi';

const RecentActivity = () => {
  // Mock data - in real app, this would come from API
  const activities = [
    {
      id: 1,
      type: 'user_registered',
      message: 'New user registered',
      user: 'John Doe',
      time: '2 minutes ago',
      icon: FiUser,
      color: 'blue',
    },
    {
      id: 2,
      type: 'course_enrolled',
      message: 'User enrolled in course',
      user: 'Jane Smith',
      course: 'Puppy Basics',
      time: '5 minutes ago',
      icon: FiBookOpen,
      color: 'green',
    },
    {
      id: 3,
      type: 'role_switched',
      message: 'User switched role',
      user: 'Mike Johnson',
      details: 'Pet Owner → Business',
      time: '10 minutes ago',
      icon: FiUserCheck,
      color: 'orange',
    },
    {
      id: 4,
      type: 'payment_received',
      message: 'Payment received',
      amount: '$49',
      time: '15 minutes ago',
      icon: FiDollarSign,
      color: 'purple',
    },
    {
      id: 5,
      type: 'course_completed',
      message: 'Course completed',
      user: 'Sarah Wilson',
      course: 'Dog Grooming',
      time: '1 hour ago',
      icon: FiBookOpen,
      color: 'green',
    },
  ];

  const getIconColor = (color) => {
    const colors = {
      blue: 'text-blue-600 bg-blue-100',
      green: 'text-green-600 bg-green-100',
      orange: 'text-orange-600 bg-orange-100',
      purple: 'text-purple-600 bg-purple-100',
      red: 'text-red-600 bg-red-100',
    };
    return colors[color] || colors.blue;
  };

  return (
    <div className="card">
      <div className="card-header">
        <h3 className="text-lg font-semibold text-gray-900">Recent Activity</h3>
      </div>
      <div className="card-body p-0">
        <div className="space-y-0">
          {activities.map((activity, index) => {
            const Icon = activity.icon;
            return (
              <div
                key={activity.id}
                className={`p-4 ${index !== activities.length - 1 ? 'border-b border-gray-100' : ''}`}
              >
                <div className="flex items-start space-x-3">
                  <div className={`p-2 rounded-lg ${getIconColor(activity.color)}`}>
                    <Icon className="w-4 h-4" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium text-gray-900">
                      {activity.message}
                    </p>
                    <div className="text-sm text-gray-600">
                      {activity.user && <span>{activity.user}</span>}
                      {activity.course && <span> - {activity.course}</span>}
                      {activity.details && <span> ({activity.details})</span>}
                      {activity.amount && <span>{activity.amount}</span>}
                    </div>
                    <p className="text-xs text-gray-500 mt-1">{activity.time}</p>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
      <div className="card-footer">
        <button className="btn btn-secondary w-full">
          View All Activity
        </button>
      </div>
    </div>
  );
};

export default RecentActivity;

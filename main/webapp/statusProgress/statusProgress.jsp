<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="statusProgress.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<jsp:useBean id="dao" class="statusProgress.statusProgressDAO" scope="page"/> 
<!DOCTYPE html>
<html charset="UTF-8">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
    <title>GanttElastic editor demo</title>
    
	<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js" ></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script> 
    <script src="https://cdn.jsdelivr.net/npm/dayjs"></script> 
 
    <script src="https://unpkg.com/gantt-elastic/dist/GanttElastic.umd.js"></script> 
    <script src="https://unpkg.com/gantt-elastic-header/dist/Header.umd.js"></script> 
    
    <link rel="stylesheet" href="./statusProgress.css?ver02">
  </head>
 
  <body>
    <div style="width:100%;height:100%">
    	<div>
    		<h4><svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-calendar-check" viewBox="0 0 16 16">
			  <path d="M10.854 7.146a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 1 1 .708-.708L7.5 9.793l2.646-2.647a.5.5 0 0 1 .708 0z"/>
			  <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
			</svg> &nbsp;진척 현황</h4>
    	</div>
		<div id="app" v-if="!destroy">
		  <gantt-elastic :tasks="tasks" :options="options" :dynamic-style="dynamicStyle">
		    <gantt-header slot="header" :options="options">
		    
		    </gantt-header>
		    <gantt-footer slot="footer"></gantt-footer>
		  </gantt-elastic>
		</div>
    </div>
 
    <script>
      // just helper to get current dates
      function getDate(hours) {
        const currentDate = new Date();
        const currentYear = currentDate.getFullYear();
        const currentMonth = currentDate.getMonth();
        const currentDay = currentDate.getDate();
        const timeStamp = new Date(currentYear, currentMonth, currentDay, 0, 0, 0).getTime();
        return new Date(timeStamp + hours * 60 * 60 * 1000).getTime();
      }
 
      let tasks = [
    	  <%
    	  List<statusProgressDTO> list=dao.getList();
    	  int index=0;
    	  int parent=0;
    	  for(int i=0; i<list.size(); i++){
    		  index++;
    		  parent=index;
    		  int flag = 0;  
			%>
				<%List<processProgressDTO> proclist=dao.getProcList(list.get(i).getItem_no()); if(proclist==null) flag=1;%>
				<%if(flag==1){%>
				{
					id: <%=index%>,
					label: '<%=list.get(i).getItem_no()%>',
					user: '<%=list.get(i).getCompany()%>',
					exp: '<%=list.get(i).getExpdate()%>',
					start: '<%=list.get(i).getStartdate()%>',
					end_date: '<%=list.get(i).getEnddate()%>',
					others: '<%=list.get(i).getCname()%>',
					duration: <%=list.get(i).getBetweendate()%>* 24 * 60 * 60 * 1000,
					type:'task',
					//collapsed: true,
					style:{
						base:{
							fill: '#C767DC'
						},
					},
				},
				<%
				}else{
				%>
				{
					id: <%=index%>,
					label: '<%=list.get(i).getItem_no()%>',
					user: '<%=list.get(i).getCompany()%>',
					exp: '<%=list.get(i).getExpdate()%>',
					start: '<%=list.get(i).getStartdate()%>',
					end_date: '<%=list.get(i).getEnddate()%>',
					others: '<%=list.get(i).getCname()%>',
					duration: <%=list.get(i).getBetweendate()%>* 24 * 60 * 60 * 1000,
					type:'task',
					collapsed: true,
					style:{
						base:{
							fill: '#C767DC'
						},
					},
				},
					<%
					for(int j=0; j<proclist.size(); j++){
						index++;
						System.out.println(dao.getProcStartdate(list.get(i).getItem_no(),proclist.get(j).getProcess()));
						if(dao.getProcStartdate(list.get(i).getItem_no(),proclist.get(j).getProcess())!=""){
					%>
						{
							id: <%=index%>,
							label: '<%=proclist.get(j).getProcess()%>',
							exp: '<%=dao.getProcExpdate(list.get(i).getItem_no(),proclist.get(j).getProcess())%>',
							start: '<%=dao.getProcStartdate(list.get(i).getItem_no(),proclist.get(j).getProcess())%>',
							end_date: '<%=dao.getProcEnddate(list.get(i).getItem_no(),proclist.get(j).getProcess())%>',
							duration: <%=dao.getProcBetDate(list.get(i).getItem_no(),proclist.get(j).getProcess())%> * 24 * 60 * 60 * 1000,
							type:'task',
							parentId: <%=parent%>,
							style:{
								base:{
									fill: '#6794DC'
								},
							},
						},
					<%
						}
					}
					%>
				<%
				}
				%>
	    	  <%
	    	  }
	    	%>    	   
      ];
 
      let options = {
        maxRows: 100,
        maxHeight: 600,
        title: {
          label: '<div class="statusbox" style="float:left; display:table-cell;"><div class="orderbox" style="display:table-cell;"></div><div class="orderexp" style="display:table-cell; background: white;"><h5 style="font-weight: bold; margin: 10px;">수주</h5></div><div class="progbox" style="display:table-cell;"></div><div class="progexp" style="display:table-cell; background: white;"><h5 style="font-weight: bold; margin: 10px;">공정</h5></div></div>',
          html: true,
        },
        row: {
          height: 24,
        },
        calendar: {
          hour: {
            display: false,
          },
        },
        chart: {
          progress: {
            bar: false,
          },
          expander: {
            display: true,
          },
        },
        taskList: {
          expander: {
            straight: false,
          },
          columns: [
            {
              id: 1,
              label: 'ID',
              value: 'id',
              width: 40,
            },
            {
              id: 2,
              label: '금형번호',
              value: 'label',
              width: 200,
              expander: true,
              html: true,
              events: {
                click({ data, column }) {
                  alert('description clicked!\n' + data.label);
                },
              },
            },
            {
              id: 3,
              label: '고객사',
              value: 'user',
              width: 68,
              html: true,
            },
            {
              id: 4,
              label: '기타',
              value: 'others',
              width: 68,
            },
            {
                id: 5,
                label: '예정종료일',
                value: 'exp',
                width: 85,
            },  
            {
                id: 6,
                label: '시작일',
                value: (task) => dayjs(task.start).format('YYYY-MM-DD'),
                width: 85,
            },
            {
                id: 7,
                label: '종료일',
                value: 'end_date',
                width: 85,
            },
            {
            	id: 8,
                label: 'Type',
                value: 'type',
                width: 0,
            },
          ],
        },
        locale:{
        Now: '현재시간',
       	  'X-Scale': 'X축 확대/축소',
          'Y-Scale': 'Y축 확대/축소',
          'Before/After': '화면 너비',
          'Task list width': '수주목록 너비',
          'Display task list': '수주목록 표시하기/숨기기',
          name: 'pl', // name String
          weekdays: '일요일_월요일_화요일_수요일_목요일_금요일_토요일'.split('_'), // weekdays Array
          weekdaysShort: '일_월_화_수_목_금_토'.split('_'), // OPTIONAL, short weekdays Array, use first three letters if not provided
          weekdaysMin: '일_월_화_수_목_금_토'.split('_'), // OPTIONAL, min weekdays Array, use first two letters if not provided
          months: '1월_2월_3월_4월_5월_6월_7월_8월_9월_10월_11월_12월'.split('_'), // months Array
          monthsShort: '1월_2월_3월_4월_5월_6월_7월_8월_9월_10월_11월_12월'.split('_'), // OPTIONAL, short months Array, use first three letters if not provided
          ordinal: n => `${n}`, // ordinal Function (number) => return number + output
          relativeTime: { // relative time format strings, keep %s %d as the same
            future: 'za %s', // e.g. in 2 hours, %s been replaced with 2hours
            past: '%s temu',
            s: 'kilka sekund',
            m: 'minutę',
            mm: '%d minut',
            h: 'godzinę',
            hh: '%d godzin', // e.g. 2 hours, %d been replaced with 2
            d: 'dzień',
            dd: '%d dni',
            M: 'miesiąc',
            MM: '%d miesięcy',
            y: 'rok',
            yy: '%d lat'
          }
       }
      };
 
      // create instance
      const app = new Vue({
        components: {
          'gantt-header': Header,
          'gantt-elastic': GanttElastic,
          'gantt-footer': {
            template: ``,
          },
        },
        data: {
          tasks: tasks.map((task) => Object.assign({}, task)),
          options,
          dynamicStyle: {
            'task-list-header-label': {
              'font-weight': 'bold',
            },
          },
          destroy: false,
        },
      });
 
      // gantt state which will be updated in realtime
      let ganttState, ganttInstance;
 
      // listen to 'gantt-elastic.ready' or 'gantt-elastic.mounted' event
      // to get the gantt state for real time modification
      app.$on('gantt-elastic-ready', (ganttElasticInstance) => {
        ganttInstance = ganttElasticInstance;
 
        ganttInstance.$on('tasks-changed', (tasks) => {
          app.tasks = tasks;
        });
        ganttInstance.$on('options-changed', (options) => {
          app.options = options;
        });
        ganttInstance.$on('dynamic-style-changed', (style) => {
          app.dynamicStyle = style;
        });
 
        ganttInstance.$on('chart-task-mouseenter', ({ data, event }) => {
          console.log('task mouse enter', { data, event });
        });
        ganttInstance.$on('updated', () => {
          //console.log('gantt view was updated');
        });
        ganttInstance.$on('destroyed', () => {
          //console.log('gantt was destroyed');
        });
        ganttInstance.$on('times-timeZoom-updated', () => {
          console.log('time zoom changed');
        });
        ganttInstance.$on('taskList-task-click', ({ event, data, column }) => {
          console.log('task list clicked! (task)', { data, column });
        });
      });
 
      // mount gantt to DOM
      app.$mount('#app');

    </script> 
  </body>
</html>
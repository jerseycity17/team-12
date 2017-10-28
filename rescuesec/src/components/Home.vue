<template>
  <v-layout column>
    <v-flex xs12 class="text-xs-center" mt-5>
      <h3>Home page {{feed}}</h3>
    </v-flex>

    <v-data-table
     v-bind:headers="headers"
     :items="feed"
     hide-actions
     class="elevation-1">
       <template slot="items" scope="feed">
         <td>{{ feed.item.user}}</td>
         <td class="text-xs-right">{{feed.item.title}}</td>
       </template>
   </v-data-table>

  </v-layout>
</template>

<script>
export default {
    // data () {
    //   return {
    //     firebase:{
    //         feed:feedRef
    //     },
    //     exampleData: [
    //         {'user': 'Neo', 'title': 'CEO'},
    //         {'user': 'Trinity', 'title': 'CTO'}
    //     ],
    //     headers: [
    //         {text: 'User', value: 'user', align: 'left'},
    //         {text: 'Title', value: 'title', align: 'left'}
    //     ]
    //   }
    // },
    computed: {
    	feed() {
    		return this.$store.getters.getFeed
    	},
    	userName() {
    		return this.$store.getters.getUser
    	}
    }
}
</script>